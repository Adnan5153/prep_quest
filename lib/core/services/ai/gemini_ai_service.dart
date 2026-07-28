import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../config/gemini_config.dart';
import '../../exceptions/app_exception.dart';
import 'ai_service.dart';

/// Google Gemini implementation of [AiService].
///
/// Speaks the public REST API directly via `dart:io`'s [HttpClient]
/// so the project does not need an extra HTTP dependency. The
/// transport is the only thing this class owns; everything else
/// (prompt construction, response parsing, normalisation) lives in
/// the data layer.
///
/// Replacing this with an OpenAI / Claude / DeepSeek implementation
/// is a drop-in change for callers — the [AiService] contract does
/// not expose any Gemini-specific surface.
class GeminiAiService implements AiService {
  GeminiAiService({
    HttpClient? httpClient,
    String? baseUrl,
    String? defaultModel,
    String? apiKey,
  })  : _injectedClient = httpClient,
        _baseUrl = baseUrl ?? GeminiConfig.restBaseUrl,
        _defaultModel = defaultModel ?? GeminiConfig.defaultModel,
        _apiKey = apiKey ?? GeminiConfig.apiKey;

  final HttpClient? _injectedClient;
  final String _baseUrl;
  final String _defaultModel;
  final String _apiKey;

  HttpClient? _ownedClient;

  HttpClient _client() {
    final HttpClient? injected = _injectedClient;
    if (injected != null) return injected;
    _ownedClient ??= HttpClient()..connectionTimeout = const Duration(seconds: 10);
    return _ownedClient!;
  }

  void _disposeOwnedClient() {
    _ownedClient?.close(force: true);
    _ownedClient = null;
  }

  @override
  String get providerName => GeminiConfig.providerName;

  @override
  String get defaultModel => _defaultModel;

  @override
  Future<AiResponse> complete(AiRequest request) async {
    final Map<String, dynamic> payload = _buildPayload(request);
    final Map<String, dynamic> responseJson =
        await _postJson(_modelPath(request.model ?? _defaultModel), payload);
    final _GeminiCandidate candidate = _firstCandidate(responseJson);
    return AiResponse(
      body: candidate.text,
      model: responseJson['modelVersion'] as String? ??
          request.model ??
          _defaultModel,
      rawJson: responseJson,
    );
  }

  @override
  Stream<String> streamComplete(AiRequest request) async* {
    final Map<String, dynamic> payload = _buildPayload(request);
    final Stream<Map<String, dynamic>> events =
        _postStream(_modelPath(request.model ?? _defaultModel), payload);
    await for (final Map<String, dynamic> event in events) {
      final _GeminiCandidate? candidate = _tryCandidate(event);
      if (candidate == null) continue;
      if (candidate.text.isEmpty) continue;
      yield candidate.text;
    }
  }

  // ---------------------------------------------------------------------------
  // Payload construction
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _buildPayload(AiRequest request) {
    final List<Map<String, dynamic>> contents = <Map<String, dynamic>>[];
    for (final AiMessage message in request.messages) {
      contents.add(_contentForRole(message.role, message.content));
    }
    final Map<String, dynamic> generationConfig = <String, dynamic>{
      'temperature': request.temperature.clamp(0.0, 2.0),
      'maxOutputTokens': request.maxOutputTokens,
    };
    if (request.jsonMode) {
      generationConfig['responseMimeType'] = 'application/json';
    }
    final Map<String, dynamic> payload = <String, dynamic>{
      'contents': contents,
      'generationConfig': generationConfig,
    };
    if (request.systemInstruction != null &&
        request.systemInstruction!.trim().isNotEmpty) {
      payload['systemInstruction'] = <String, dynamic>{
        'parts': <Map<String, dynamic>>[
          <String, dynamic>{'text': request.systemInstruction},
        ],
      };
    }
    return payload;
  }

  Map<String, dynamic> _contentForRole(AiMessageRole role, String text) {
    final String mapped = switch (role) {
      AiMessageRole.system => 'system',
      AiMessageRole.user => 'user',
      AiMessageRole.assistant => 'model',
      AiMessageRole.tool => 'function',
    };
    return <String, dynamic>{
      'role': mapped,
      'parts': <Map<String, dynamic>>[
        <String, dynamic>{'text': text},
      ],
    };
  }

  String _modelPath(String model) {
    return '${_baseUrl.replaceAll(RegExp(r'/+$'), '')}/v1beta/models/'
        '$model:generateContent';
  }

  String _streamPath(String model) {
    return '${_baseUrl.replaceAll(RegExp(r'/+$'), '')}/v1beta/models/'
        '$model:streamGenerateContent?alt=sse';
  }

  // ---------------------------------------------------------------------------
  // Transport
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _postJson(
    String url,
    Map<String, dynamic> payload,
  ) async {
    if (_apiKey.isEmpty) {
      throw const RemoteException(
        'Gemini API key is not configured. Pass '
        '--dart-define=GEMINI_API_KEY=... at build time or route calls '
        'through a proxy.',
        code: 'missing-api-key',
      );
    }
    final HttpClient http = _client();
    final Uri uri = Uri.parse(url);
    final HttpClientRequest req = await http.postUrl(uri);
    req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    req.headers.set('x-goog-api-key', _apiKey);
    req.headers.set(HttpHeaders.acceptHeader, 'application/json');
    req.write(jsonEncode(payload));
    final HttpClientResponse res =
        await req.close().timeout(GeminiConfig.requestTimeout);
    final String body = await res.transform(utf8.decoder).join();
    return _parseResponse(res.statusCode, body);
  }

  Stream<Map<String, dynamic>> _postStream(
    String url,
    Map<String, dynamic> payload,
  ) async* {
    if (_apiKey.isEmpty) {
      throw const RemoteException(
        'Gemini API key is not configured. Pass '
        '--dart-define=GEMINI_API_KEY=... at build time or route calls '
        'through a proxy.',
        code: 'missing-api-key',
      );
    }
    final HttpClient http = _client();
    final Uri uri = Uri.parse(_streamPath(Uri.parse(url).pathSegments.last));
    final HttpClientRequest req = await http.postUrl(uri);
    req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    req.headers.set('x-goog-api-key', _apiKey);
    req.headers.set(HttpHeaders.acceptHeader, 'text/event-stream');
    req.write(jsonEncode(payload));
    final HttpClientResponse res =
        await req.close().timeout(GeminiConfig.requestTimeout);
    if (res.statusCode >= 400) {
      final String body = await res.transform(utf8.decoder).join();
      _parseResponse(res.statusCode, body);
      throw StateError('unreachable');
    }
    final Stream<String> lines = res.transform(utf8.decoder).transform(const LineSplitter());
    String buffer = '';
    await for (final String line in lines) {
      if (line.startsWith('data:')) {
        buffer = line.substring(5).trim();
        if (buffer.isNotEmpty) {
          final dynamic decoded = jsonDecode(buffer);
          if (decoded is Map<String, dynamic>) yield decoded;
        }
        buffer = '';
      } else if (line.isEmpty) {
        buffer = '';
      }
    }
  }

  Map<String, dynamic> _parseResponse(int statusCode, String body) {
    Map<String, dynamic>? decoded;
    if (body.isNotEmpty) {
      try {
        final dynamic raw = jsonDecode(body);
        if (raw is Map<String, dynamic>) decoded = raw;
      } on FormatException {
        decoded = null;
      }
    }
    if (statusCode >= 200 && statusCode < 300) {
      return decoded ??
          <String, dynamic>{'_unparsed': body, 'modelVersion': _defaultModel};
    }
    final String? message = decoded == null
        ? null
        : (decoded['error'] is Map<String, dynamic>
            ? (decoded['error'] as Map<String, dynamic>)['message'] as String?
            : null);
    throw RemoteException(
      message ?? 'Gemini request failed with status $statusCode',
      code: statusCode.toString(),
    );
  }

  // ---------------------------------------------------------------------------
  // Response extraction
  // ---------------------------------------------------------------------------

  _GeminiCandidate _firstCandidate(Map<String, dynamic> json) {
    final dynamic rawCandidates = json['candidates'];
    if (rawCandidates is! List || rawCandidates.isEmpty) {
      throw const RemoteException(
        'Gemini returned no candidates.',
        code: 'empty-response',
      );
    }
    final _GeminiCandidate? candidate =
        _tryCandidate(<String, dynamic>{'candidates': rawCandidates});
    if (candidate == null) {
      throw const RemoteException(
        'Gemini returned no usable text.',
        code: 'empty-text',
      );
    }
    return candidate;
  }

  _GeminiCandidate? _tryCandidate(Map<String, dynamic> json) {
    final dynamic rawCandidates = json['candidates'];
    if (rawCandidates is! List || rawCandidates.isEmpty) return null;
    final dynamic first = rawCandidates.first;
    if (first is! Map<String, dynamic>) return null;
    final dynamic content = first['content'];
    if (content is! Map<String, dynamic>) return null;
    final dynamic parts = content['parts'];
    if (parts is! List) return null;
    final StringBuffer buffer = StringBuffer();
    for (final dynamic part in parts) {
      if (part is Map<String, dynamic> && part['text'] is String) {
        buffer.write(part['text'] as String);
      }
    }
    if (buffer.isEmpty) return null;
    return _GeminiCandidate(buffer.toString());
  }

  /// Closes the owned [HttpClient]. Safe to call when no client was
  /// created or when one was injected.
  void dispose() {
    _disposeOwnedClient();
  }
}

@immutable
class _GeminiCandidate {
  const _GeminiCandidate(this.text);
  final String text;
}

import 'dart:convert';

/// Discriminated result of parsing an AI response.
class AiParsedResponse {
  const AiParsedResponse._({
    required this.bodyText,
    required this.parsedJson,
    required this.usedFallback,
  });

  factory AiParsedResponse.json(Map<String, dynamic> json) {
    final String body = _extractBody(json).trim();
    return AiParsedResponse._(
      bodyText: body,
      parsedJson: json,
      usedFallback: false,
    );
  }

  factory AiParsedResponse.fallback(String text) {
    return AiParsedResponse._(
      bodyText: text,
      parsedJson: null,
      usedFallback: true,
    );
  }

  final String bodyText;
  final Map<String, dynamic>? parsedJson;

  /// `true` when the body was returned as plain text rather than JSON.
  final bool usedFallback;

  static String _extractBody(Map<String, dynamic> json) {
    final Object? direct = json['body'];
    if (direct is String) return direct;
    final Object? text = json['text'];
    if (text is String) return text;
    return jsonEncode(json);
  }
}

/// Decodes a raw AI response body.
///
/// Tries JSON first (every Prep Quest generator endpoint requests
/// `responseMimeType=application/json`); when parsing fails or the
/// payload is empty, falls back to the raw markdown body so callers
/// still see a usable answer.
class AiResponseParser {
  const AiResponseParser();

  AiParsedResponse parse(String rawBody) {
    final String trimmed = rawBody.trim();
    if (trimmed.isEmpty) {
      return AiParsedResponse.fallback('');
    }
    final String unwrapped = _stripCodeFence(trimmed);
    try {
      final dynamic decoded = jsonDecode(unwrapped);
      if (decoded is Map<String, dynamic>) {
        return AiParsedResponse.json(decoded);
      }
      if (decoded is List) {
        return AiParsedResponse.json(<String, dynamic>{'_list': decoded});
      }
    } on FormatException {
      // fall through to markdown fallback
    }
    return AiParsedResponse.fallback(trimmed);
  }

  String _stripCodeFence(String body) {
    if (!body.startsWith('```')) return body;
    final int firstNewline = body.indexOf('\n');
    if (firstNewline == -1) return body;
    final String tail = body.substring(firstNewline + 1);
    final int fenceEnd = tail.lastIndexOf('```');
    if (fenceEnd == -1) return tail;
    return tail.substring(0, fenceEnd).trim();
  }
}

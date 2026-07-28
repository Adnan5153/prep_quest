import 'dart:async';

import 'package:flutter/foundation.dart';

/// Role of a participant in a chat conversation.
///
/// Mirrors the canonical OpenAI / Gemini / Claude role vocabulary so
/// any AI provider can map onto it without losing context.
enum AiMessageRole { system, user, assistant, tool }

/// A single message exchanged with an AI provider.
///
/// Plain-text-only by design — providers that support multi-part
/// content (images, audio, tool calls) expose those via dedicated
/// fields on their concrete service implementations.
@immutable
class AiMessage {
  const AiMessage({required this.role, required this.content});

  final AiMessageRole role;
  final String content;
}

/// Generation parameters shared by every provider.
///
/// `model` is optional — the [AiService] falls back to its configured
/// default when the caller leaves it null. `temperature` and
/// `maxOutputTokens` are clamped to provider-supported ranges inside
/// the concrete service.
@immutable
class AiRequest {
  const AiRequest({
    required this.messages,
    this.model,
    this.temperature = 0.4,
    this.maxOutputTokens = 1024,
    this.systemInstruction,
    this.jsonMode = false,
  });

  final List<AiMessage> messages;
  final String? model;
  final double temperature;
  final int maxOutputTokens;
  final String? systemInstruction;

  /// When true, the service asks the provider to emit JSON only.
  ///
  /// Implementations may translate this to the provider's structured-
  /// output flag (Gemini `responseMimeType`, OpenAI `response_format`,
  /// …) or fall back to a system-instruction nudge.
  final bool jsonMode;
}

/// Raw response returned by an AI provider.
///
/// `body` is always populated (the rendered answer text). `rawJson`
/// is the decoded JSON payload from the provider when one is
/// available — useful for analytics and provider-specific metadata.
@immutable
class AiResponse {
  const AiResponse({
    required this.body,
    required this.model,
    this.rawJson,
  });

  final String body;
  final String model;
  final Map<String, dynamic>? rawJson;
}

/// Provider-agnostic contract for any generative AI backend.
///
/// The presentation layer must never depend on a concrete
/// implementation directly — it goes through this interface, which
/// the data layer satisfies. Adding a new provider (OpenAI, Claude,
/// DeepSeek, an on-device model, …) only requires writing a new
/// implementation of [AiService] and swapping the binding in DI.
abstract class AiService {
  String get providerName;

  String get defaultModel;

  Future<AiResponse> complete(AiRequest request);

  Stream<String> streamComplete(AiRequest request);
}

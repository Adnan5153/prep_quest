import '../../features/quiz_api/data/models/quiz_pagination_model.dart';

/// Typed access to the Quiz Hub REST API envelope.
///
/// Every Quiz Hub response is either:
///
/// ```json
/// { "success": true, "message": "...", "data": { ... } | [ ... ], "pagination": { ... } }
/// ```
///
/// or an error response:
///
/// ```json
/// { "success": false, "message": "...", "errors": [ { "path": "...", "message": "..." } ] }
/// ```
///
/// [ApiEnvelope.from] decodes the success branch and throws an
/// [EnvelopeException] when the server reports a failure or the payload
/// is missing mandatory fields.
class ApiEnvelope {
  const ApiEnvelope({
    required this.message,
    required this.data,
    required this.pagination,
  });

  /// Server-side message (informational, never localised).
  final String? message;

  /// Decoded payload. Either a single object or a list, depending on
  /// the endpoint. The data layer is responsible for further mapping.
  final Object? data;

  /// Pagination metadata, present on every paginated list response.
  final QuizPaginationModel? pagination;

  /// Decodes a Quiz Hub response into a typed [ApiEnvelope].
  factory ApiEnvelope.from(ResponseLike response) {
    final dynamic body = response.body;
    if (body is! Map<String, dynamic>) {
      throw const EnvelopeException('Unexpected response shape (not an object).');
    }
    final bool success = body['success'] == true;
    if (!success) {
      final String message = (body['message'] as String? ?? 'Request failed').trim();
      throw EnvelopeException(
        message.isEmpty ? 'Request failed' : message,
        errors: body['errors'],
      );
    }
    final Object? data = body['data'];
    final dynamic paginationRaw = body['pagination'];
    final QuizPaginationModel? pagination = paginationRaw is Map<String, dynamic>
        ? QuizPaginationModel.fromJson(paginationRaw)
        : null;
    return ApiEnvelope(
      message: body['message'] as String?,
      data: data,
      pagination: pagination,
    );
  }
}

/// Minimal surface [ApiEnvelope.from] needs from a `Response`.
///
/// Keeping this as a structural interface lets the envelope helper stay
/// decoupled from `dio.Response` so unit tests can pass plain maps.
abstract class ResponseLike {
  Map<String, dynamic> get body;
}

class EnvelopeException implements Exception {
  const EnvelopeException(this.message, {this.errors});

  final String message;
  final Object? errors;

  @override
  String toString() => 'EnvelopeException: $message';
}

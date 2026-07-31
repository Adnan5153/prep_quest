import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/network/dio_client.dart';
import '../models/quiz_category_model.dart';
import '../models/quiz_pagination_model.dart';
import '../models/quiz_question_model.dart';
import 'quiz_api_remote_datasource.dart';

/// Quiz Hub REST datasource backed by [DioClient].
///
/// Talks to the public Quiz Hub API documented in `docs/apidoc/api`.
/// `Authorization` headers are *not* attached because the backend is
/// public; the [AuthInterceptor] only attaches a token when callers
/// set the `X-Require-Auth` header explicitly.
class HttpQuizApiRemoteDataSource implements QuizApiRemoteDataSource {
  HttpQuizApiRemoteDataSource({
    required DioClient client,
    Map<String, String>? extraHeaders,
  })  : _client = client,
        _extraHeaders = <String, String>{...?extraHeaders};

  final DioClient _client;
  final Map<String, String> _extraHeaders;

  Options _options({bool responseTypeBytes = false}) => Options(
        headers: <String, String>{..._extraHeaders},
        responseType: responseTypeBytes ? ResponseType.bytes : ResponseType.json,
        followRedirects: true,
      );

  Future<ApiEnvelope> _decode(Response<dynamic> response) async {
    final _ResponseShim shim = _ResponseShim(response.data);
    return ApiEnvelope.from(shim);
  }

  @override
  Future<QuizCategoryPage> listCategories(QuizCategoryQuery query) async {
    final Response<dynamic> response = await _client.dio.get<dynamic>(
      ApiEndpoints.quizCategories,
      queryParameters: <String, dynamic>{
        ...query.toQueryParameters(),
        if (query.search != null && query.search!.isNotEmpty)
          'search': query.search,
      },
      options: _options(),
    );
    final ApiEnvelope envelope = await _decode(response);
    final List<dynamic> items = envelope.data is List
        ? envelope.data as List<dynamic>
        : <dynamic>[];
    return (
      items: items
          .whereType<Map<String, dynamic>>()
          .map(QuizCategoryModel.fromJson)
          .toList(growable: false),
      pagination: envelope.pagination ??
          const QuizPaginationModel(
            page: 1,
            limit: 20,
            totalItems: 0,
            totalPages: 0,
            hasNext: false,
            hasPrevious: false,
          ),
    );
  }

  @override
  Future<QuizCategoryModel> getCategory(String id) async {
    final Response<dynamic> response = await _client.dio.get<dynamic>(
      ApiEndpoints.quizCategoryById(id),
      options: _options(),
    );
    final ApiEnvelope envelope = await _decode(response);
    return QuizCategoryModel.fromApiResponse(envelope.data is Map<String, dynamic>
        ? envelope.data as Map<String, dynamic>
        : <String, dynamic>{});
  }

  @override
  Future<QuizCategoryModel> createCategory({
    required String name,
    String? description,
  }) async {
    final Map<String, dynamic> body = <String, dynamic>{'name': name};
    if (description != null) body['description'] = description;
    final Response<dynamic> response = await _client.dio.post<dynamic>(
      ApiEndpoints.quizCategories,
      data: body,
      options: _options(),
    );
    final ApiEnvelope envelope = await _decode(response);
    return QuizCategoryModel.fromApiResponse(envelope.data is Map<String, dynamic>
        ? envelope.data as Map<String, dynamic>
        : <String, dynamic>{});
  }

  @override
  Future<QuizCategoryModel> updateCategory({
    required String id,
    required String name,
    String? description,
  }) async {
    final Map<String, dynamic> body = <String, dynamic>{'name': name};
    if (description != null) body['description'] = description;
    final Response<dynamic> response = await _client.dio.put<dynamic>(
      ApiEndpoints.quizCategoryById(id),
      data: body,
      options: _options(),
    );
    final ApiEnvelope envelope = await _decode(response);
    return QuizCategoryModel.fromApiResponse(envelope.data is Map<String, dynamic>
        ? envelope.data as Map<String, dynamic>
        : <String, dynamic>{});
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _client.dio.delete<dynamic>(
      ApiEndpoints.quizCategoryById(id),
      options: _options(),
    );
  }

  @override
  Future<QuizQuestionPage> listQuestionsForCategory(
    String categoryId,
    QuizQuestionQuery query,
  ) async {
    final Map<String, dynamic> params = <String, dynamic>{
      ...query.toQueryParameters(),
    };
    if (query.search != null && query.search!.isNotEmpty) {
      params['search'] = query.search;
    }
    final Response<dynamic> response = await _client.dio.get<dynamic>(
      ApiEndpoints.quizQuestions(categoryId),
      queryParameters: params,
      options: _options(),
    );
    final ApiEnvelope envelope = await _decode(response);
    final List<dynamic> items = envelope.data is List
        ? envelope.data as List<dynamic>
        : <dynamic>[];
    return (
      items: items
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> json) => QuizQuestionModel.fromJson(
                <String, dynamic>{'categoryId': categoryId, ...json},
              ))
          .toList(growable: false),
      pagination: envelope.pagination ??
          const QuizPaginationModel(
            page: 1,
            limit: 20,
            totalItems: 0,
            totalPages: 0,
            hasNext: false,
            hasPrevious: false,
          ),
    );
  }

  @override
  Future<QuizQuestionModel> createQuestion({
    required String categoryId,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    required int mark,
  }) async {
    final Response<dynamic> response = await _client.dio.post<dynamic>(
      ApiEndpoints.quizQuestions(categoryId),
      data: <String, dynamic>{
        'question': prompt,
        'options': options,
        'answerIndex': answerIndex,
        'mark': mark,
      },
      options: _options(),
    );
    final ApiEnvelope envelope = await _decode(response);
    final dynamic data = envelope.data;
    final Map<String, dynamic> body = data is Map<String, dynamic>
        ? <String, dynamic>{'categoryId': categoryId, ...data}
        : <String, dynamic>{'categoryId': categoryId};
    return QuizQuestionModel.fromJson(body);
  }

  @override
  Future<List<QuizQuestionModel>> getRandomQuestions({
    required String categoryId,
    int count = 10,
  }) async {
    final Response<dynamic> response = await _client.dio.get<dynamic>(
      ApiEndpoints.quizRandomQuestions(categoryId),
      queryParameters: <String, dynamic>{'count': count},
      options: _options(),
    );
    final ApiEnvelope envelope = await _decode(response);
    final List<dynamic> items = envelope.data is List
        ? envelope.data as List<dynamic>
        : <dynamic>[];
    return items
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> json) => QuizQuestionModel.fromJson(
              <String, dynamic>{'categoryId': categoryId, ...json},
            ))
        .toList(growable: false);
  }

  @override
  Future<QuizQuestionModel> getQuestion(String id) async {
    final Response<dynamic> response = await _client.dio.get<dynamic>(
      ApiEndpoints.quizQuestionById(id),
      options: _options(),
    );
    final ApiEnvelope envelope = await _decode(response);
    return QuizQuestionModel.fromApiResponse(envelope.data is Map<String, dynamic>
        ? envelope.data as Map<String, dynamic>
        : <String, dynamic>{});
  }

  @override
  Future<QuizQuestionModel> updateQuestion({
    required String id,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    required int mark,
  }) async {
    final Response<dynamic> response = await _client.dio.put<dynamic>(
      ApiEndpoints.quizQuestionById(id),
      data: <String, dynamic>{
        'question': prompt,
        'options': options,
        'answerIndex': answerIndex,
        'mark': mark,
      },
      options: _options(),
    );
    await _decode(response);
    final Map<String, dynamic> body = <String, dynamic>{
      'id': id,
      'question': prompt,
      'options': options,
      'answerIndex': answerIndex,
      'mark': mark,
    };
    return QuizQuestionModel.fromJson(body);
  }

  @override
  Future<void> deleteQuestion(String id) async {
    await _client.dio.delete<dynamic>(
      ApiEndpoints.quizQuestionById(id),
      options: _options(),
    );
  }

  @override
  Future<int> bulkDeleteQuestions({
    required String categoryId,
    required List<String> ids,
  }) async {
    final Response<dynamic> response = await _client.dio.post<dynamic>(
      ApiEndpoints.quizBulkDelete(categoryId),
      data: <String, dynamic>{'ids': ids},
      options: _options(),
    );
    final ApiEnvelope envelope = await _decode(response);
    final dynamic data = envelope.data;
    if (data is Map<String, dynamic>) {
      final dynamic inserted = data['inserted'] ?? data['deleted'] ?? data['count'];
      if (inserted is num) return inserted.toInt();
    }
    final String? message = envelope.message;
    if (message != null) {
      final RegExpMatch? match = RegExp(r'(\d+)').firstMatch(message);
      if (match != null) return int.tryParse(match.group(1) ?? '') ?? ids.length;
    }
    return ids.length;
  }

  @override
  Future<int> importQuestions({
    required String categoryId,
    required List<Map<String, dynamic>> questions,
  }) async {
    final Response<dynamic> response = await _client.dio.post<dynamic>(
      ApiEndpoints.quizImportQuestions(categoryId),
      data: questions,
      options: _options(),
    );
    final ApiEnvelope envelope = await _decode(response);
    final dynamic data = envelope.data;
    if (data is Map<String, dynamic>) {
      final dynamic inserted = data['inserted'] ?? data['count'];
      if (inserted is num) return inserted.toInt();
    }
    return questions.length;
  }

  @override
  Future<List<int>> exportQuestions({
    required String categoryId,
    String format = 'json',
  }) async {
    final Response<dynamic> response = await _client.dio.get<dynamic>(
      ApiEndpoints.quizExportQuestions(categoryId),
      queryParameters: <String, dynamic>{'format': format},
      options: _options(responseTypeBytes: true),
    );
    final dynamic body = response.data;
    if (body is List<int>) return List<int>.unmodifiable(body);
    if (body is Uint8List) return List<int>.unmodifiable(body);
    if (body is String) {
      return List<int>.unmodifiable(body.codeUnits);
    }
    return const <int>[];
  }
}

class _ResponseShim implements ResponseLike {
  _ResponseShim(this._body);

  final dynamic _body;

  @override
  Map<String, dynamic> get body {
    if (_body is Map<String, dynamic>) return _body;
    return <String, dynamic>{};
  }
}
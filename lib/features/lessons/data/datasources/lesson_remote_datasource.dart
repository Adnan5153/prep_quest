import '../models/lesson_model.dart';

abstract class LessonRemoteDataSource {
  Future<List<LessonModel>> fetchAllLessons();
  Future<List<LessonModel>> fetchLessonsForNode(String nodeId);
  Future<LessonModel?> fetchLessonById(String id);
  Future<LessonModel?> fetchLessonBySlug(String slug);
}
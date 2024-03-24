import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../util/logger/logger.dart';
import 'model/question.dart';
import 'model/student.dart';

part 'api.g.dart';

@RestApi(baseUrl: '')
abstract class QaTeacherApiClient {
  factory QaTeacherApiClient(Dio dio, {String baseUrl}) = _QaTeacherApiClient;

  static const Map<String, String> headers = {
    "Accept": "application/json",
    "Access-Control_Allow_Origin": "*",
  };

  factory QaTeacherApiClient.create({String? apiUrl}) {
    final dio = Dio();
    // Добавление интерцептора логирования
    dio.interceptors.add(LogInterceptor(
      request: false,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      requestHeader: false,
      error: true,
      logPrint: (object) {
        appLogger.d(object.toString()); // Использование вашего логгера
      },
    ));

    if (apiUrl != null) {
      return QaTeacherApiClient(dio, baseUrl: apiUrl);
    }
    return QaTeacherApiClient(Dio());
  }

  @GET('/getStudentList')
  Future<List<Student>> getStudentList();

  @GET('/getQuestions')
  Future<List<Question>> getQuestionList();

  @POST('/startLesson')
  Future<List<Question>> startLesson(@Field('studentId') int studentId);

  @PUT('/finishLesson')
  Future<void> finishLesson(@Field('studentId') int studentId);

  @PUT('/updateQuestion')
  Future<void> updateQuestion({
    @Field('questionId') required int questionId,
    @Field('questionText') required String questionText,
    @Field('answerForTeacherText') required String answerForTeacherText,
    @Field('lessonNumber') required int lessonNumber,
  });

  @POST('/addQuestion')
  Future<void> addQuestion({
    @Field('questionText') required String questionText,
    @Field('answerForTeacherText') required String answerForTeacherText,
    @Field('lessonNumber') required int lessonNumber,
  });

  @POST('/createStudent')
  Future<bool> createStudent(@Field('fullName') String fullName);

  @PUT('/updateProgress')
  Future<void> updateProgress({
    @Field('studentId') required int studentId,
    @Field('questionId') required int questionId,
    @Field('rateAnswer') required int rateAnswer,
  });
}

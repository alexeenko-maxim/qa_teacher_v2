import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  int questionId;
  String questionText;
  String answerForTeacherText;
  int lessonNumber;

  Question({
    required this.questionId,
    required this.questionText,
    required this.answerForTeacherText,
    required this.lessonNumber,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionId: json["questionId"],
        questionText: json["questionText"],
        answerForTeacherText: json["answerForTeacherText"],
        lessonNumber: json["lessonNumber"],
      );
}

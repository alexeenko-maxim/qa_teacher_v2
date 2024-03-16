// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      studentId: json['studentId'] as int,
      questionId: json['questionId'] as int,
      questionText: json['questionText'] as String,
      answerForTeacherText: json['answerForTeacherText'] as String,
      lessonNumber: json['lessonNumber'] as int,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'studentId': instance.studentId,
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'answerForTeacherText': instance.answerForTeacherText,
      'lessonNumber': instance.lessonNumber,
    };

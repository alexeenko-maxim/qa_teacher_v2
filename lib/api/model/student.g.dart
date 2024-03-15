// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      studentId: json['studentId'] as int,
      fullName: json['fullName'] as String,
      currentLessonNumber: json['currentLessonNumber'] as int,
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'studentId': instance.studentId,
      'fullName': instance.fullName,
      'currentLessonNumber': instance.currentLessonNumber,
    };

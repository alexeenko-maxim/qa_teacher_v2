
import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart';

@JsonSerializable()
class Student {
  int studentId;
  String fullName;
  int currentLessonNumber;

  Student({
    required this.studentId,
    required this.fullName,
    required this.currentLessonNumber,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    studentId: json["studentId"],
    fullName: json["fullName"],
    currentLessonNumber: json["currentLessonNumber"],
  );
}
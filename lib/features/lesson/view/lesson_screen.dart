import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:qa_teacher/api/model/student.dart';
import 'package:qa_teacher/features/lesson/widgets/lesson_app_bar.dart';
import 'package:qa_teacher/features/lesson/widgets/question_list_view.dart';

@RoutePage()
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LessonAppBar(student: Student(studentId: 1, fullName: 'testStudent', currentLessonNumber: 1)),
      body: QuestionListView(student: Student(studentId: 1, fullName: 'testStudent', currentLessonNumber: 1),
      ),
    );
  }
}
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:qa_teacher/router/router.dart';

import '../../../api/model/student.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({super.key});

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
          ),
        ),
        SliverList.builder(
          itemCount: 5,
          itemBuilder: (context, index) => StudentRow(
            student: Student(
                studentId: index,
                fullName: 'TestStudent_$index',
                currentLessonNumber: 1),
          ),
        ),
      ],
    );
  }
}

class StudentRow extends StatelessWidget {
  const StudentRow({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            student.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Пройденно уроков: [${student.currentLessonNumber}]'),
              const SizedBox(
                width: 20,
              ),
              Text('Осталось уроков: [${30 - (student.currentLessonNumber)}]'),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                  onPressed: () {
                    AutoRouter.of(context).push(const LessonRoute());
                  },
                  child: const Text('Начать следующий урок',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      )))
            ],
          ),
        ],
      ),
    );
  }
}

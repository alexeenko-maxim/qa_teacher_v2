import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:qa_teacher/router/router.dart';

import '../../../api/model/student.dart';

class StudentsList extends StatefulWidget {
  final Future<List<Student>> studentsList;

  const StudentsList({Key? key, required this.studentsList}) : super(key: key);

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Student>>(
      future: widget.studentsList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка загрузки: ${snapshot.error.toString()}'));
        } else if (snapshot.hasData) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
              SliverList.builder(
                itemCount: snapshot.data!.length, // Предполагаем, что snapshot.data содержит ваш список студентов
                itemBuilder: (context, index) {
                  final student = snapshot.data![index];
                  return StudentRow(
                    student: student, // StudentRow - предполагаемый виджет для отображения информации о студенте
                  );
                },
              ),
            ],
          );
        } else {
          return const Center(child: Text('Студенты не найдены'));
        }
      },
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
                    //final questions = await apiClient.startLesson(student.studentId); // Предполагаем, что student - это объект вашей модели Student
                    //AutoRouter.of(context).push(LessonRoute(questions: questions)); // Предполагаем, что LessonRoute принимает список вопросов
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

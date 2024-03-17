import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qa_teacher/api/model/question.dart';
import 'package:qa_teacher/router/router.dart';

import '../../../api/api.dart';
import '../../../api/model/student.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final QaTeacherApiClient apiClient;
  late Future<List<Student>> studentsList;

  @override
  void initState() {
    super.initState();
    apiClient =
        QaTeacherApiClient.create(apiUrl: dotenv.env['API_URL']); // Пример инициализации, адаптируйте под свой случай
    studentsList = apiClient.getStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Убран const
      appBar: const HomeAppBar(),
      body: StudentsList(studentsList: studentsList),
    );
  }
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey,
      title: const Text(
        'Панель управления',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              onPressed: () {
                // Действия при нажатии на Кнопка 1
              },
              child: const Text(
                'Список студентов',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

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

class StudentRow extends StatefulWidget {
  StudentRow({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  State<StudentRow> createState() => _StudentRowState();
}

class _StudentRowState extends State<StudentRow> {
  late final QaTeacherApiClient apiClient;
  late Future<List<Question>> questionList;

  @override
  void initState() {
    super.initState();
    apiClient =
        QaTeacherApiClient.create(apiUrl: dotenv.env['API_URL']); // Пример инициализации, адаптируйте под свой случай
    questionList = apiClient.startLesson(1);
    print(questionList);
  }

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
            widget.student.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Пройденно уроков: [${widget.student.currentLessonNumber}]'),
              const SizedBox(
                width: 20,
              ),
              Text('Осталось уроков: [${30 - (widget.student.currentLessonNumber)}]'),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                  onPressed: () async {
                    print(widget.student.studentId);
                    final questions = await apiClient.startLesson(widget.student.studentId);
                    print(questionList.toString());
                    AutoRouter.of(context).push(LessonRoute(
                        student: widget.student,
                        questionList: questions)); // Предполагаем, что LessonRoute принимает сп
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

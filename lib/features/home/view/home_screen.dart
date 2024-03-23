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
      appBar: HomeAppBar(onAddStudentPressed: () => _showAddStudentDialog(context)),
      body: StudentsList(studentsList: studentsList),
    );
  }

  Future<void> _showAddStudentDialog(BuildContext context) async {
    final TextEditingController _nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить нового ученика'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Имя ученика"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Добавить'),
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  await apiClient.createStudent(_nameController.text);
                  // Обновите список учеников здесь, если это необходимо
                  Navigator.of(context).pop();
                  _refreshStudentsList(); // Предполагается, что эта функция обновляет список студентов
                }
              },
            ),
          ],
        );
      },
    );
  }
  void _refreshStudentsList() {
    setState(() {
      studentsList = apiClient.getStudentList();
    });
  }
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddStudentPressed;
  const HomeAppBar({Key? key, required this.onAddStudentPressed}) : super(key: key);

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
              onPressed: onAddStudentPressed,
              child: const Text(
                'Создать нового ученика',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                AutoRouter.of(context).push(KnowledgeRoute());
                // Действия при нажатии на Кнопка 1
              },
              child: const Text(
                'База знаний',
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
    apiClient = QaTeacherApiClient.create(apiUrl: dotenv.env['API_URL']);
    questionList = apiClient.startLesson(widget.student.studentId);
  }

  @override
  Widget build(BuildContext context) {
    // Определение, является ли устройство мобильным
    final isMobileDevice = isMobile(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
      child: isMobileDevice
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildMobileLayout(),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buildDesktopLayout(),
      ),
    );
  }

  List<Widget> buildMobileLayout() {
    return [
      Text(
        widget.student.fullName,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 8),
      Text('Пройденно уроков: [${widget.student.currentLessonNumber}]'),
      SizedBox(height: 8),
      Text('Осталось уроков: [${30 - widget.student.currentLessonNumber}]'),
      SizedBox(height: 8),
      TextButton(
        onPressed: () async {
          final questions = await apiClient.startLesson(widget.student.studentId);
          AutoRouter.of(context).push(LessonRoute(student: widget.student, questionList: questions, apiClient: apiClient));
        },
        child: const Text('Начать следующий урок', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      )
    ];
  }

  List<Widget> buildDesktopLayout() {
    return [
      Expanded(
        child: Text(
          widget.student.fullName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      Expanded(
        child: Text('Пройденно уроков: [${widget.student.currentLessonNumber}]'),
      ),
      Expanded(
        child: Text('Осталось уроков: [${30 - widget.student.currentLessonNumber}]'),
      ),
      TextButton(
        onPressed: () async {
          final questions = await apiClient.startLesson(widget.student.studentId);
          AutoRouter.of(context).push(LessonRoute(student: widget.student, questionList: questions, apiClient: apiClient));
        },
        child: const Text('Начать следующий урок', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      )
    ];
  }


  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
}


import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qa_teacher/api/model/question.dart';
import 'package:qa_teacher/router/router.dart';

import '../../../api/api.dart';
import '../../../api/model/student.dart';
import '../bloc/student/student_bloc.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentBloc>(
      create: (_) => StudentBloc(
        apiClient: QaTeacherApiClient.create(apiUrl: dotenv.env['API_URL']),
      )..add(LoadStudentsEvent()),
      child: Scaffold(
        appBar: HomeAppBar(
          onAddStudentPressed: () => _showAddStudentDialog(context),
        ),
        body: StudentsList(),
      ),
    );
  }

  Future<void> _showAddStudentDialog(BuildContext context) async {
    final TextEditingController _nameController = TextEditingController();
    final studentBloc = BlocProvider.of<StudentBloc>(context);
    print(studentBloc.state);

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
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  // Получаем блок и отправляем событие
                  context.read<StudentBloc>().add(CreateStudentEvent(name: _nameController.text));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
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
      title: const Text(
        'Панель управления',
      ),
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              onPressed: onAddStudentPressed,
              child: const Text(
                'Создать нового ученика',
                style: TextStyle(
                  color: Colors.white,
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
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StudentsList extends StatelessWidget {
  StudentsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        print('BlocBuilder state: $state');
        if (state is StudentsLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StudentsLoadFailure) {
          return Center(child: Text('Ошибка загрузки: ${state.error}'));
        } else if (state is StudentsLoadSuccess) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
              SliverList.builder(
                itemCount: state.students.length,
                itemBuilder: (context, index) {
                  return StudentRow(student: state.students[index]);
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
          AutoRouter.of(context)
              .push(LessonRoute(student: widget.student, questionList: questions, apiClient: apiClient));
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
          AutoRouter.of(context)
              .push(LessonRoute(student: widget.student, questionList: questions, apiClient: apiClient));
        },
        child: const Text('Начать следующий урок', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      )
    ];
  }

  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
}

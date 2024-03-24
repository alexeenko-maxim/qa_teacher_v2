import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qa_teacher/api/model/question.dart';
import 'package:qa_teacher/router/router.dart';

import '../../../api/api.dart';
import '../../../api/model/student.dart';
import '../bloc/student/student_bloc.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final GlobalKey<StudentsListState> studentsListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentBloc>(
      create: (context) => StudentBloc(
        apiClient: RepositoryProvider.of<QaTeacherApiClient>(context),
      )..add(LoadStudentsEvent()),
      child: Scaffold(
        appBar: HomeAppBar(
          onAddStudentPressed: (key) { // Измените тип параметра здесь
            _showAddStudentDialog(context, key);
          },
          studentsListKey: studentsListKey, // Передайте ключ
        ),
        body: StudentsList(key: studentsListKey),
      ),
    );
  }
}

Future<void> _showAddStudentDialog(BuildContext context, GlobalKey<StudentsListState> key) async {
  final TextEditingController nameController = TextEditingController();
  final studentBloc = BlocProvider.of<StudentBloc>(context);
  print('Открыт диалог создание студента, studentBloc.state = ${studentBloc.state}');

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
                controller: nameController,
                decoration: const InputDecoration(hintText: "Имя ученика"),
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
              if (nameController.text.isNotEmpty) {
                // Добавляем студента
                context.read<StudentBloc>().add(CreateStudentEvent(name: nameController.text));

                // Закрываем диалоговое окно
                Navigator.of(context).pop();

                // Обновляем список студентов
                key.currentState?.refreshList();
              }
            },
          ),
        ],
      );
    },
  );
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(GlobalKey<StudentsListState>) onAddStudentPressed;
  final GlobalKey<StudentsListState> studentsListKey; // Добавьте это поле

  const HomeAppBar({
    Key? key,
    required this.onAddStudentPressed,
    required this.studentsListKey, // И добавьте это в конструктор
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Панель управления'),
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              onPressed: () => onAddStudentPressed(studentsListKey), // Используйте ключ здесь
              child: const Text(
                'Создать нового ученика',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                AutoRouter.of(context).push(const KnowledgeRoute());
              },
              child: const Text(
                'База знаний',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StudentsList extends StatefulWidget {
  const StudentsList({Key? key}) : super(key: key);

  @override
  State<StudentsList> createState() => StudentsListState();
}

class StudentsListState extends State<StudentsList> {

  void refreshList() {
    setState(() {
      print('ВЫзов метода setState из refreshList');
      context.read<StudentBloc>().add(LoadStudentsEvent());
    });
    // setState(() {
    //   print('ВЫзов метода setState из refreshList');
    //   context.read<StudentBloc>().add(LoadStudentsEvent());
    // });

  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentBloc, StudentState>(
      listener: (context, state) {
        if (state is StudentsLoadFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Ошибка загрузки: ${state.error}')),
            );
        }
      },
      builder: (context, state) {
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
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return StudentRow(student: state.students[index]);
                  },
                  childCount: state.students.length,
                ),
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
  const StudentRow({
    super.key,
    required this.student,
  });
  final Student student;

  @override
  State<StudentRow> createState() => _StudentRowState();
}

class _StudentRowState extends State<StudentRow> {
  late Future<List<Question>> questionList;

  @override
  Widget build(BuildContext context) {
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
      const SizedBox(height: 8),
      Text('Пройденно уроков: [${widget.student.currentLessonNumber}]'),
      const SizedBox(height: 8),
      Text('Осталось уроков: [${30 - widget.student.currentLessonNumber}]'),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () async {
          _startLesson(context); // Вызываем функцию без async
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
          _startLesson(context); // Вызываем функцию без async
        },
        child: const Text('Начать следующий урок', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      )
    ];
  }

  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  void _startLesson(BuildContext context) async {
    // Сохраняем состояние навигатора до асинхронной операции
    final NavigatorState navigator = Navigator.of(context);

    // Показываем индикатор загрузки
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Получаем экземпляр QaTeacherApiClient из контекста
    final apiClient = RepositoryProvider.of<QaTeacherApiClient>(context);

    try {
      // Асинхронно запускаем урок и получаем список вопросов
      final questions = await apiClient.startLesson(widget.student.studentId);

      // Проверяем, что виджет еще в дереве виджетов
      if (!mounted) return;

      // Закрываем индикатор загрузки, используя сохраненное состояние навигатора
      navigator.pop();

      // Переходим на экран урока, передавая необходимые данные
      AutoRouter.of(context).push(LessonRoute(
        student: widget.student,
        questionList: questions,
        apiClient: apiClient,
      ));
    } catch (error) {
      // Проверяем, что виджет еще в дереве виджетов
      if (!mounted) return;

      // Закрываем индикатор загрузки, используя сохраненное состояние навигатора
      navigator.pop();

      // Показываем ошибку, используя контекст, связанный с навигатором
      ScaffoldMessenger.of(navigator.context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $error')),
      );
    }
  }
}

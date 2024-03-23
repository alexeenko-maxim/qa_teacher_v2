import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:qa_teacher/api/model/question.dart';
import 'package:qa_teacher/api/model/student.dart';

import '../../../api/api.dart';
import '../../../router/router.dart';

@RoutePage()
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.student, required this.questionList, required this.apiClient});

  final Student student;
  final List<Question> questionList;
  final QaTeacherApiClient apiClient; // Добавляем это поле

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  void initState() {
    print(widget.student.studentId);
    print(widget.questionList.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LessonAppBar(student: widget.student),
      body: _QuestionListView(
        student: widget.student,
        questionList: widget.questionList,
        apiClient: widget.apiClient, // Передаем экземпляр apiClient
      ),
    );
  }
}

class LessonAppBar extends StatefulWidget implements PreferredSizeWidget {
  const LessonAppBar({super.key, required this.student});

  final Student student;

  @override
  State<LessonAppBar> createState() => _LessonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _LessonAppBarState extends State<LessonAppBar> {
  @override
  Widget build(BuildContext context) {
    // Использование AppBar вместо SliverAppBar
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Студент: [${widget.student.fullName}]'),
          const SizedBox(width: 20),
          Text('Номер занятия: [${widget.student.currentLessonNumber}]'),
        ],
      ),
    );
  }
}

class _QuestionListView extends StatefulWidget {
  _QuestionListView({
    Key? key,
    required this.student,
    required this.questionList,
    required this.apiClient,
  }) : super(key: key);

  final Student student;
  List<Question> questionList;
  final QaTeacherApiClient apiClient; // Укажите тип вашего API клиента

  @override
  State<_QuestionListView> createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<_QuestionListView> {
  bool canFinishLesson = false; // Добавляем состояние для активации кнопки

  Future<void> _updateQuestionList() async {
    var updatedList = await widget.apiClient.startLesson(widget.student.studentId);
    setState(() {
      widget.questionList = updatedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 30,
          ),
        ),
        SliverList.builder(
          itemBuilder: (context, index) => QuestionRow(
            questionNumber: index,
            question: widget.questionList[index].questionText,
            answerForTeacher: widget.questionList[index].answerForTeacherText,
            answerRate: 0, // Используйте реальное значение rate
            apiClient: widget.apiClient,
            studentId: widget.student.studentId, // Передайте studentId
            questionId: widget.questionList[index].questionId,
            onUpdate: _updateQuestionList, // Передайте метод обновления списка вопросов
          ),
          itemCount: widget.questionList.length,
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 240,
                  height: 40,
                  child: TextButton(
                    onPressed: widget.questionList.isEmpty
                        ? () async {
                            // Вызов finishLesson
                            await widget.apiClient.finishLesson(widget.student.studentId);

                            // Переход на экран статистики (предполагается, что у вас есть Route для этого экрана)
                            AutoRouter.of(context).push(StatisticsRoute(studentId: widget.student.studentId));
                          }
                        : null, // Если список вопросов не пуст, кнопка будет неактивной
                    child: const Text('Завершить урок'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: widget.questionList.isEmpty ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
          ),
        ),
      ],
    );
  }
}

class QuestionRow extends StatefulWidget {
  const QuestionRow(
      {super.key,
      required this.question,
      required this.answerForTeacher,
      required this.answerRate,
      required this.apiClient,
      required this.onUpdate,
      required this.studentId,
      required this.questionId,
      required this.questionNumber});
  final QaTeacherApiClient apiClient; // Укажите тип вашего API клиента
  final String question;
  final String answerForTeacher;
  final int answerRate;
  final Function onUpdate;
  final int studentId; // Добавьте это поле
  final int questionId;
  final int questionNumber;

  @override
  State<QuestionRow> createState() => _QuestionRowState();
}

class _QuestionRowState extends State<QuestionRow> {
  // Переменная для хранения текущей оценки
  int currentRate = 0;
  int ratingWidgetKey = 0;

  void _resetRatingWidget() {
    setState(() {
      // Изменяем ключ, заставляя Flutter пересоздать RatingWidget
      ratingWidgetKey++;
    });
  }

  void _submitRating() async {
    await widget.apiClient.updateProgress(
      studentId: widget.studentId,
      questionId: widget.questionId, // Предполагается, что у вас есть доступ к ID вопроса
      rateAnswer: currentRate,
    );

    // Сброс текущей оценки после успешной отправки
    setState(() {
      currentRate = 0; // Сбрасываем значение оценки после отправки
    });

    // Сбрасываем рейтинг и обновляем список вопросов
    _resetRatingWidget();
    widget.onUpdate(); // Вызовите функцию обновления, переданную через конструктор
  }

  @override
  Widget build(BuildContext context) {
    // Проверяем, мобильное ли это устройство
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
      child: isMobile ? buildMobileLayout() : buildDesktopLayout(),
    );
  }

  Widget buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Вопрос ${widget.questionNumber+1}',
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Text(
          widget.question,
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Text(
          widget.answerForTeacher,
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16), // Добавляем пространство между текстом и кнопками
        Column(
          children: [
            RatingWidget(
              maxRating: 3,
              onChanged: (int value) {},
            ),
            const SizedBox(width: 16), // Добавляем пространство между рейтингом и кнопкой
            TextButton(
              onPressed: _submitRating,
              child: const Text(
                'Оценить',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Вопрос ${widget.questionNumber+1}',
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Text(
                widget.question,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Text(
                widget.answerForTeacher,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Row(
          children: [
            RatingWidget(
              key: ValueKey(ratingWidgetKey), // Используем уникальный ключ
              maxRating: 3,
              onChanged: (int value) {
                setState(() {
                  currentRate = value;
                });
              },
            ),
            const SizedBox(width: 40),
            TextButton(
              onPressed: _submitRating,
              child: const Text(
                'Оценить',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RatingWidget extends StatefulWidget {
  final int maxRating;
  final ValueChanged<int> onChanged;

  const RatingWidget({Key? key, required this.maxRating, required this.onChanged}) : super(key: key);

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late int currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = 0; // Изначально все звезды неактивны
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.maxRating, (index) {
        return IconButton(
          icon: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              currentRating = index + 1; // Устанавливаем текущую оценку
              widget.onChanged(currentRating); // Вызываем обратный вызов при изменении оценки
            });
          },
        );
      }),
    );
  }
}

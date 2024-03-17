import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:qa_teacher/api/model/question.dart';
import 'package:qa_teacher/api/model/student.dart';

@RoutePage()
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.student, required this.questionList});

  final Student student;
  final List<Question> questionList;

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
  const _QuestionListView({
    Key? key,
    required this.student,
    required this.questionList,
  }) : super(key: key);

  final Student student;
  final List<Question> questionList;

  @override
  State<_QuestionListView> createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<_QuestionListView> {
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
            question: widget.questionList[index].questionText,
            answerForTeacher: widget.questionList[index].answerForTeacherText,
            answerRate: 0,
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
                    onPressed: () {},
                    child: const Text('Завершить урок'),
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
  const QuestionRow({super.key, required this.question, required this.answerForTeacher, required this.answerRate});

  final String question;
  final String answerForTeacher;
  final int answerRate;

  @override
  State<QuestionRow> createState() => _QuestionRowState();
}

class _QuestionRowState extends State<QuestionRow> {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.question,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.answerForTeacher,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  RatingWidget(
                    maxRating: 3,
                    onChanged: (int value) {},
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Оценить',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
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

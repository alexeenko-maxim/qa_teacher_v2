import 'package:flutter/material.dart';
import 'package:qa_teacher/api/model/student.dart';

import 'question_row.dart';

class QuestionListView extends StatefulWidget {
  const QuestionListView({
    Key? key,
    required this.student,
  }) : super(key: key);

  final Student student;

  @override
  State<QuestionListView> createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {
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
          itemBuilder: (context, index) => const QuestionRow(
            question: 'Что такое тестирование и каковы его цели',
            answerForTeacher:
                'Тестирование это проверка соответствия между ожидаемым поведение и фактическим. Цели тестирования: 1) убедиться что ПО соответствует предоставленным требованиям 2) предоставить актуальную информацию о состоянии ПО на текущий момент 3) поиск дефектов',
            answerRate: 0,
          ),
          itemCount: 10,
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

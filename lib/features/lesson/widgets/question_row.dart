import 'package:flutter/material.dart';

import 'rating_widget.dart';

class QuestionRow extends StatefulWidget {
  const QuestionRow(
      {super.key,
      required this.question,
      required this.answerForTeacher,
      required this.answerRate});

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
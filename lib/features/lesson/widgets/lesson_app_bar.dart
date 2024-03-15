import 'package:flutter/material.dart';
import 'package:qa_teacher/api/model/student.dart';


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
    return SliverAppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Cтудент: [${widget.student.fullName}]'),
          const SizedBox(
            width: 20,
          ),
          Text('Номер занятия: [${widget.student.currentLessonNumber}]'),
        ],
      ),
      floating: true,
      snap: true,
      pinned: true,
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:qa_teacher/api/model/question.dart';
import 'package:qa_teacher/api/model/student.dart';
import 'package:qa_teacher/features/knowledge/knowledge_screen.dart';
import 'package:qa_teacher/features/lesson/view/lesson_screen.dart';

import '../api/api.dart';
import '../features/home/view/home_screen.dart';
import '../features/statistic/view/statistic_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/'),
        AutoRoute(page: LessonRoute.page, path: '/lesson'),
        AutoRoute(page: KnowledgeRoute.page, path: '/knowledge'),
        AutoRoute(page: EditQuestionRoute.page, path: '/editQuestion'),
        AutoRoute(page: AddQuestionRoute.page, path: '/addQuestion'),
        AutoRoute(page: StatisticsRoute.page, path: '/staistic'),
      ];
}

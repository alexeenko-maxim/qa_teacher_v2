import 'package:auto_route/auto_route.dart';
import 'package:qa_teacher/features/lesson/view/lesson_screen.dart';

import '../features/home/view/home_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/'),
        AutoRoute(page: LessonRoute.page, path: '/lesson'),
      ];
}
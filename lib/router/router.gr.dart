// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    LessonRoute.name: (routeData) {
      final args = routeData.argsAs<LessonRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LessonScreen(
          key: args.key,
          student: args.student,
          questionList: args.questionList,
        ),
      );
    },
  };
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LessonScreen]
class LessonRoute extends PageRouteInfo<LessonRouteArgs> {
  LessonRoute({
    Key? key,
    required Student student,
    required List<Question> questionList,
    List<PageRouteInfo>? children,
  }) : super(
          LessonRoute.name,
          args: LessonRouteArgs(
            key: key,
            student: student,
            questionList: questionList,
          ),
          initialChildren: children,
        );

  static const String name = 'LessonRoute';

  static const PageInfo<LessonRouteArgs> page = PageInfo<LessonRouteArgs>(name);
}

class LessonRouteArgs {
  const LessonRouteArgs({
    this.key,
    required this.student,
    required this.questionList,
  });

  final Key? key;

  final Student student;

  final List<Question> questionList;

  @override
  String toString() {
    return 'LessonRouteArgs{key: $key, student: $student, questionList: $questionList}';
  }
}

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
    AddQuestionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddQuestionScreen(),
      );
    },
    EditQuestionRoute.name: (routeData) {
      final args = routeData.argsAs<EditQuestionRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditQuestionScreen(
          key: args.key,
          questionId: args.questionId,
          questionText: args.questionText,
          answerForTeacherText: args.answerForTeacherText,
          lessonNumber: args.lessonNumber,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomeScreen(key: args.key),
      );
    },
    KnowledgeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KnowledgeScreen(),
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
          apiClient: args.apiClient,
        ),
      );
    },
    StatisticsRoute.name: (routeData) {
      final args = routeData.argsAs<StatisticsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: StatisticsScreen(
          key: args.key,
          studentId: args.studentId,
        ),
      );
    },
  };
}

/// generated route for
/// [AddQuestionScreen]
class AddQuestionRoute extends PageRouteInfo<void> {
  const AddQuestionRoute({List<PageRouteInfo>? children})
      : super(
          AddQuestionRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddQuestionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EditQuestionScreen]
class EditQuestionRoute extends PageRouteInfo<EditQuestionRouteArgs> {
  EditQuestionRoute({
    Key? key,
    required int questionId,
    required String questionText,
    required String answerForTeacherText,
    required int lessonNumber,
    List<PageRouteInfo>? children,
  }) : super(
          EditQuestionRoute.name,
          args: EditQuestionRouteArgs(
            key: key,
            questionId: questionId,
            questionText: questionText,
            answerForTeacherText: answerForTeacherText,
            lessonNumber: lessonNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'EditQuestionRoute';

  static const PageInfo<EditQuestionRouteArgs> page =
      PageInfo<EditQuestionRouteArgs>(name);
}

class EditQuestionRouteArgs {
  const EditQuestionRouteArgs({
    this.key,
    required this.questionId,
    required this.questionText,
    required this.answerForTeacherText,
    required this.lessonNumber,
  });

  final Key? key;

  final int questionId;

  final String questionText;

  final String answerForTeacherText;

  final int lessonNumber;

  @override
  String toString() {
    return 'EditQuestionRouteArgs{key: $key, questionId: $questionId, questionText: $questionText, answerForTeacherText: $answerForTeacherText, lessonNumber: $lessonNumber}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          HomeRoute.name,
          args: HomeRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<HomeRouteArgs> page = PageInfo<HomeRouteArgs>(name);
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [KnowledgeScreen]
class KnowledgeRoute extends PageRouteInfo<void> {
  const KnowledgeRoute({List<PageRouteInfo>? children})
      : super(
          KnowledgeRoute.name,
          initialChildren: children,
        );

  static const String name = 'KnowledgeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LessonScreen]
class LessonRoute extends PageRouteInfo<LessonRouteArgs> {
  LessonRoute({
    Key? key,
    required Student student,
    required List<Question> questionList,
    required QaTeacherApiClient apiClient,
    List<PageRouteInfo>? children,
  }) : super(
          LessonRoute.name,
          args: LessonRouteArgs(
            key: key,
            student: student,
            questionList: questionList,
            apiClient: apiClient,
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
    required this.apiClient,
  });

  final Key? key;

  final Student student;

  final List<Question> questionList;

  final QaTeacherApiClient apiClient;

  @override
  String toString() {
    return 'LessonRouteArgs{key: $key, student: $student, questionList: $questionList, apiClient: $apiClient}';
  }
}

/// generated route for
/// [StatisticsScreen]
class StatisticsRoute extends PageRouteInfo<StatisticsRouteArgs> {
  StatisticsRoute({
    Key? key,
    required int studentId,
    List<PageRouteInfo>? children,
  }) : super(
          StatisticsRoute.name,
          args: StatisticsRouteArgs(
            key: key,
            studentId: studentId,
          ),
          initialChildren: children,
        );

  static const String name = 'StatisticsRoute';

  static const PageInfo<StatisticsRouteArgs> page =
      PageInfo<StatisticsRouteArgs>(name);
}

class StatisticsRouteArgs {
  const StatisticsRouteArgs({
    this.key,
    required this.studentId,
  });

  final Key? key;

  final int studentId;

  @override
  String toString() {
    return 'StatisticsRouteArgs{key: $key, studentId: $studentId}';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:qa_teacher/router/router.dart';
import 'package:qa_teacher/theme/app_theme.dart';
import 'package:qa_teacher/util/logger/navigation_logger.dart';
import 'package:qa_teacher/util/logger/simple_bloc_observer.dart';

import 'api/api.dart';
import 'features/home/bloc/student/student_bloc.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });

  runApp(const QaTeacherApp());
}

class QaTeacherApp extends StatelessWidget {
  const QaTeacherApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String apiUrl = dotenv.env['API_URL']!;
    final qaTeacherApiClient = QaTeacherApiClient.create(apiUrl: apiUrl);

    return MultiProvider(
      providers: [
        RepositoryProvider<QaTeacherApiClient>.value(value: qaTeacherApiClient),
        BlocProvider<StudentBloc>(
          create: (context) => StudentBloc(apiClient: qaTeacherApiClient),
        ),
      ],
      child: MaterialApp.router(
        title: 'QaTeacher',
        theme: AppTheme.lightTheme,
        routerDelegate: AppRouter().delegate(
          navigatorObservers: () => [LoggingNavigatorObserver()],
        ),
        routeInformationParser: AppRouter().defaultRouteParser(),
      ),
    );
  }
}

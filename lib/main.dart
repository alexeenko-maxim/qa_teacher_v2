import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:qa_teacher/router/router.dart';
import 'package:qa_teacher/theme/app_theme.dart';
import 'package:qa_teacher/util/logger/navigation_logger.dart';
import 'package:qa_teacher/util/logger/simple_bloc_observer.dart';

import 'api/api.dart';
import 'features/home/bloc/student/student_bloc.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  // Гарантирует, что все необходимые компоненты Flutter, такие как рендеринг, синхронизация состояний и т. д., будут инициализированы до запуска вашего приложения
  WidgetsFlutterBinding.ensureInitialized();
  // Загружаем файл с переменными окружения
  await dotenv.load(fileName: ".env");
  Logger.root.level = Level.ALL; // Записывать все сообщения
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });


  runApp(const QaTeacherApp());
}

class QaTeacherApp extends StatefulWidget {
  const QaTeacherApp({super.key});

  @override
  State<QaTeacherApp> createState() => _QaTeacherAppState();
}

class _QaTeacherAppState extends State<QaTeacherApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    final apiClient = QaTeacherApiClient.create(apiUrl: dotenv.env['API_URL']);
    return BlocProvider<StudentBloc>(
      create: (context) => StudentBloc(apiClient: apiClient), // Создаем экземпляр StudentBloc
      child: MaterialApp.router(
        title: 'QaTeacher',
        theme: AppTheme.lightTheme,
        routerDelegate: _router.delegate(
          navigatorObservers: () => [LoggingNavigatorObserver()],
        ),
        routeInformationParser: _router.defaultRouteParser(),
      ),
    );
  }
}

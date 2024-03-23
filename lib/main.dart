import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qa_teacher/router/router.dart';
import 'package:qa_teacher/util/logger/navigation_logger.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  // Гарантирует, что все необходимые компоненты Flutter, такие как рендеринг, синхронизация состояний и т. д., будут инициализированы до запуска вашего приложения
  WidgetsFlutterBinding.ensureInitialized();
  // Загружаем файл с переменными окружения
  await dotenv.load(fileName: ".env");
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
    return MaterialApp.router(
      title: 'QaTeacher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerDelegate: _router.delegate(
        navigatorObservers: () => [LoggingNavigatorObserver()], // Добавьте свой RouteObserver
      ),
      routeInformationParser: _router.defaultRouteParser(),
    );
  }
}

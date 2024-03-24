import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:qa_teacher/router/router.dart';

@RoutePage()
class StatisticsScreen extends StatelessWidget {
  final int studentId;

  const StatisticsScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Переопределяем действие кнопки "Назад"
        AutoRouter.of(context).popUntilRouteWithName(HomeRoute.name);
        // Возвращаем false, чтобы сообщить системе, что нам не нужно дополнительно обрабатывать событие "назад"
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Статистика урока'),
        ),
        body: Center(
          child: Text('Здесь будет статистика для студента с ID $studentId'),
        ),
      ),
    );
  }
}

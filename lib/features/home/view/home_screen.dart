import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../api/api.dart';
import '../../../api/model/student.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/student_list.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final QaTeacherApiClient apiClient;
  late Future<List<Student>> studentsList;

  @override
  void initState() {
    super.initState();
    apiClient = QaTeacherApiClient.create(apiUrl: dotenv.env['API_URL']); // Пример инициализации, адаптируйте под свой случай
    studentsList = apiClient.getStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Убран const
      appBar: const HomeAppBar(),
      body: StudentsList(studentsList: studentsList),
    );
  }
}


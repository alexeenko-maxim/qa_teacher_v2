import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../api/model/student.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/student_list.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});



  @override
  State<HomeScreen> createState() => _HomeScreenState();

}




class _HomeScreenState extends State<HomeScreen> {
  late final QaTeacherApiClient apiClient;
  late Future<List<Student>> studentsFuture;

  @override
  void initState() {
    super.initState();
    studentsFuture = apiClient.getStudentList(); // Адаптируйте к вашему API клиенту
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: StudentsList(),
    );
  }
}

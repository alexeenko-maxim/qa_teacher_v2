import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../api/api.dart';
import '../../../../api/model/student.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final QaTeacherApiClient apiClient;

  StudentBloc({required this.apiClient}) : super(StudentsInitial()) {
    on<LoadStudentsEvent>(_onLoadStudents);
    on<CreateStudentEvent>(_onCreateStudent);
  }

  Future<void> _onLoadStudents(LoadStudentsEvent event, Emitter<StudentState> emit) async {
    emit(StudentsLoadInProgress());
    try {
      final students = await apiClient.getStudentList();
      final studentStrings = students.map((student) => student.fullName).join(", ");
      print('Вызов final students = await apiClient.getStudentList(); в _onLoadStudents, \n Sudents loaded successfully: $studentStrings');
      emit(StudentsLoadSuccess(students));
      print('Вызов emit(StudentsLoadSuccess(students)); в _onLoadStudents, \n students: ${students.map((student) => student.fullName).join(", ")}');
    } catch (e) {
      emit(StudentsLoadFailure(e.toString()));
      print('Error loading students: $e');
    }
  }

  Future<void> _onCreateStudent(CreateStudentEvent event, Emitter<StudentState> emit) async {
    print('Вызов метода _onCreateStudent');
    try {
      await apiClient.createStudent(event.name);
      final students = await apiClient.getStudentList();
      emit(StudentsLoadSuccess(students));
      print('Вызов emit(StudentsLoadSuccess(students)); в _onCreateStudent, \n students: ${students.map((student) => student.fullName).join(", ")}');
    } catch (e) {
      print('Error creating student: $e');
      emit(StudentsLoadFailure(e.toString()));
    }
  }
}
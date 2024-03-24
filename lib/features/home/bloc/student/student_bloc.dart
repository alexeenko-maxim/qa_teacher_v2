import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
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
      print('Students loaded successfully: $studentStrings');
      emit(StudentsLoadSuccess(students));
      // Логирование успешной загрузки
      print('Students loaded successfully');
    } catch (e) {
      emit(StudentsLoadFailure(e.toString()));
      // Логирование ошибки загрузки
      print('Error loading students: $e');
    }
  }
  Future<void> _onCreateStudent(CreateStudentEvent event, Emitter<StudentState> emit) async {
    try {
      await apiClient.createStudent(event.name);
      // Опционально: вызвать загрузку списка студентов после добавления нового
      add(LoadStudentsEvent());
    } catch (e) {
      print('Error creating student: $e');
      emit(StudentsLoadFailure(e.toString()));
    }
  }
}
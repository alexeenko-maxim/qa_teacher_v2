part of 'student_bloc.dart';

sealed class StudentState extends Equatable {
  @override
  List<Object> get props => [];
}

class StudentsInitial extends StudentState {}

class StudentsLoadInProgress extends StudentState {}

class StudentsLoadSuccess extends StudentState {
  final List<Student> students;
  final DateTime timestamp;

  StudentsLoadSuccess(this.students) : timestamp = DateTime.now();

  @override
  List<Object> get props => [students, timestamp];
}

class StudentsLoadFailure extends StudentState {
  final String error;

  StudentsLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

part of 'student_bloc.dart';

@immutable
abstract class StudentState extends Equatable {
  @override
  List<Object> get props => [];
}

class StudentsInitial extends StudentState {}

class StudentsLoadInProgress extends StudentState {}

class StudentsLoadSuccess extends StudentState {
  final List<Student> students;

  StudentsLoadSuccess(this.students);

  @override
  List<Object> get props => [students];
}

class StudentsLoadFailure extends StudentState {
  final String error;

  StudentsLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

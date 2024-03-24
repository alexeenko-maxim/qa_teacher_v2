
part of 'student_bloc.dart';


@immutable
abstract class StudentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadStudentsEvent extends StudentEvent {
  @override
  List<Object> get props => [];
}

class CreateStudentEvent extends StudentEvent {
  final String name;

  CreateStudentEvent({required this.name});

}


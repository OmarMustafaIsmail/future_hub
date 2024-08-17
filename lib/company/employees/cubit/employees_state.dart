import 'package:future_hub/common/auth/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeesState extends Equatable {}

class EmployeesLoading extends EmployeesState {
  @override
  List<Object?> get props => [];
}

class EmployeesLoadFailed extends EmployeesState {
  @override
  List<Object?> get props => [];
}

class EmployeesLoaded extends EmployeesState {
  final List<User> employees;

  EmployeesLoaded(this.employees);

  @override
  List<Object?> get props => [employees];
}

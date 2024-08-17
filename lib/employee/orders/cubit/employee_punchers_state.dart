import 'package:future_hub/employee/orders/models/puncher_branch.dart';

abstract class EmployeePunchersState {}

class EmployeePunchersInitState extends EmployeePunchersState {}

class EmployeePunchersChangeScreenState extends EmployeePunchersState {}

class ChangePunchersState extends EmployeePunchersState {}

class PunchersLoadedState extends EmployeePunchersState {
  final List<PuncherBranch> punchers;
  final bool canLoadMore;
  PunchersLoadedState(this.punchers, this.canLoadMore);
}

class PunchersLoadingState extends EmployeePunchersState {
  final List<PuncherBranch> oldPunchers;
  final bool isFirstFetch;

  PunchersLoadingState(this.oldPunchers, {this.isFirstFetch = false});
}

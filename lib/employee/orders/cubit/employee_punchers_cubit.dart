import 'package:future_hub/employee/orders/cubit/employee_punchers_state.dart';
import 'package:future_hub/employee/orders/models/puncher_branch.dart';
import 'package:future_hub/employee/orders/services/punchers_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeePunchersCubit extends Cubit<EmployeePunchersState> {
  EmployeePunchersCubit() : super(EmployeePunchersInitState());

  static EmployeePunchersCubit get(context) => BlocProvider.of(context);

  int page = 1;

  final _punchersService = PunchersServices();

  List<PuncherBranch> cubitPunchers = [];

  loadPunchers({bool refresh = false}) async {
    if (state is PunchersLoadingState) return;
    final currentState = state;
    var oldPunchers = <PuncherBranch>[];
    if (currentState is PunchersLoadedState) {
      oldPunchers = currentState.punchers;
    }
    if (refresh) {
      page = 1;
      oldPunchers = [];
    }
    emit(
      PunchersLoadingState(
        oldPunchers,
        isFirstFetch: page == 1,
      ),
    );
    var newPunchers = await _punchersService.fetchBranches(page);
    page++;
    final punchers = (state as PunchersLoadingState).oldPunchers;
    punchers.addAll(newPunchers.data);
    cubitPunchers = punchers;
    emit(
      PunchersLoadedState(
        punchers,
        newPunchers.hasMorePages,
      ),
    );
  }

  changeCubitPunchers(List<PuncherBranch> punchers) {
    cubitPunchers = punchers;
    emit(ChangePunchersState());
  }

  int screenIndex = 0;

  changeScreenIndex(int index, List<PuncherBranch> punchers) {
    screenIndex = index;
    cubitPunchers = punchers;
    emit(EmployeePunchersChangeScreenState());
  }
}

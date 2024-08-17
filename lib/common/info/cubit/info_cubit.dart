import 'package:bloc/bloc.dart';
import 'package:future_hub/common/info/cubit/info_state.dart';
import 'package:future_hub/common/info/services/info_service.dart';

class InfoCubit extends Cubit<InfoState> {
  InfoCubit() : super(InfoLoading());

  final InfoService _infoService = InfoService();

  Future<void> init() async {
    final info = await _infoService.getInfo();
    emit(InfoLoaded(info));
  }
}

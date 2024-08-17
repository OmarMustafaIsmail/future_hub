import 'package:future_hub/common/info/models/info_model.dart';
import 'package:equatable/equatable.dart';

abstract class InfoState extends Equatable {}

class InfoLoading extends InfoState {
  @override
  List<Object?> get props => [];
}

class InfoLoaded extends InfoState {
  final Info info;

  InfoLoaded(this.info);

  @override
  List<Object?> get props => [info];
}

import 'package:equatable/equatable.dart';

class CarYear extends Equatable {
  final int id;
  final String title;

  const CarYear({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}

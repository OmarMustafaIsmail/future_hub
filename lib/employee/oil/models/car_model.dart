import 'package:equatable/equatable.dart';

class CarModel extends Equatable {
  final int id;
  final String title;

  const CarModel({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}

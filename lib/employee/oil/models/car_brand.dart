import 'package:equatable/equatable.dart';

class CarBrand extends Equatable {
  final int id;
  final String title;
  final String? imageURL;

  const CarBrand({
    required this.id,
    required this.title,
    this.imageURL,
  });

  @override
  List<Object?> get props => [id, title, imageURL];
}

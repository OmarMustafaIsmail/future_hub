import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final String? id;
  final String? name;
  final bool canUpdatePrice;
  final bool customerPointsBenefit;
  final bool pointsBenefit;
  final String? imageURL;

  const Company({
    this.id,
    this.name,
    bool? canUpdatePrice,
    bool? customerPointsBenefit,
    bool? pointsBenefit,
    this.imageURL,
  })  : canUpdatePrice = canUpdatePrice ?? false,
        customerPointsBenefit = customerPointsBenefit ?? false,
        pointsBenefit = pointsBenefit ?? false;

  @override
  List<Object?> get props => [
        id,
        name,
        canUpdatePrice,
        customerPointsBenefit,
        pointsBenefit,
        imageURL,
      ];
}

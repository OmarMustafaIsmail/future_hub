import 'package:future_hub/employee/orders/models/puncher.dart';

class PuncherBranch {
  final String id;
  final String? title;
  final String? address;
  final String? latitude;
  final String? longitude;
  final City? city;
  final double? distance;
  final Puncher puncher;

  const PuncherBranch({
    required this.id,
    required this.puncher,
    this.title,
    this.address,
    this.latitude,
    this.longitude,
    this.city,
    this.distance,
  });
}

class City {
  String id;
  String? title;
  int? active;
  int? position;

  City({
    required this.id,
    this.title,
    this.active,
    this.position,
  });
}

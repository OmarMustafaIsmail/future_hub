import 'package:equatable/equatable.dart';
import 'package:future_hub/common/auth/models/company.dart';

class User extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final String? birthDate;
  final String? imageURL;
  final String? type;
  final String? nationalId;
  final String? username;
  final bool? exists;
  final bool? active;
  final double limit;
  final double spentAmount;
  final double wallet;
  final int points;
  final DateTime? createdAt;
  final Company? company;

  const User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.birthDate,
    this.imageURL,
    this.type,
    this.nationalId,
    this.username,
    this.exists,
    this.active,
    this.createdAt,
    this.company,
    double? limit,
    double? spentAmount,
    double? wallet,
    int? points,
  })  : limit = limit ?? 0,
        spentAmount = spentAmount ?? 0,
        wallet = wallet ?? 0,
        points = points ?? 0;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        gender,
        birthDate,
        imageURL,
        type,
        nationalId,
        username,
        exists,
        active,
        limit,
        wallet,
        createdAt,
        spentAmount,
        points,
        company,
      ];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? birthDate,
    String? imageURL,
    String? type,
    String? nationalId,
    String? username,
    bool? exists,
    bool? active,
    double? limit,
    double? spentAmount,
    double? wallet,
    int? points,
    Company? company,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      imageURL: imageURL ?? this.imageURL,
      type: type ?? this.type,
      nationalId: nationalId ?? this.nationalId,
      username: username ?? this.username,
      exists: exists ?? this.exists,
      active: active ?? this.active,
      company: company ?? this.company,
      limit: limit ?? this.limit,
      spentAmount: spentAmount ?? this.spentAmount,
      wallet: wallet ?? this.wallet,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

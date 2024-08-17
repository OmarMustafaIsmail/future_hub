import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final String id;
  final String message;
  final DateTime? createdAt;
  final bool seen;

  const Notification({
    required this.id,
    required this.message,
    required this.seen,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, createdAt, message, seen];
}

import 'package:future_hub/common/info/models/question_model.dart';
import 'package:equatable/equatable.dart';

class Info extends Equatable {
  final String about;
  final String terms;
  final String phone;
  final String email;
  final String privacy;
  final List<Question> questions;
  final String? excelUserUploadExample;
  final String imagePath;

  const Info({
    required this.about,
    required this.phone,
    required this.email,
    required this.terms,
    required this.questions,
    required this.privacy,
    this.excelUserUploadExample,
    required this.imagePath,
  });

  @override
  List<Object?> get props =>
      [about, terms, questions, privacy, excelUserUploadExample, imagePath];
}

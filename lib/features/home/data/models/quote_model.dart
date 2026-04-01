import '../../domain/entities/quote.dart';

class QuoteModel extends Quote {
  QuoteModel({
    required super.id,
    required super.content,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'],
      content: json['content'],
    );
  }
}
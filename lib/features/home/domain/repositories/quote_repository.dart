import '../entities/quote.dart';

abstract class IQuoteRepository {
  Future<List<Quote>> getQuotes();
}
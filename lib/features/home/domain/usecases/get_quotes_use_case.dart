import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class GetQuotesUseCase {
  final IQuoteRepository _repository;

  GetQuotesUseCase(this._repository);

  Future<List<Quote>> execute() {
    return _repository.getQuotes();
  }
}

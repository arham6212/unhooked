import '../../domain/entities/quote.dart';
import '../../domain/repositories/quote_repository.dart';
import 'quote_remote_datasource_impl.dart';

class QuoteRepositoryImpl implements IQuoteRepository {
  final QuoteRemoteDataSource remoteDataSource;

  QuoteRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Quote>> getQuotes() async {
    return await remoteDataSource.fetchQuotes();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/quote_remote_datasource_impl.dart';
import '../../data/repositories/quote_repository_impl.dart';
import '../../domain/repositories/quote_repository.dart';
import '../../domain/usecases/get_quotes_use_case.dart';
import '../../domain/entities/quote.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final quoteRemoteDataSourceProvider = Provider<QuoteRemoteDataSource>((ref) {
  return QuoteRemoteDataSourceImpl(ref.watch(supabaseClientProvider));
});

final quoteRepositoryProvider = Provider<IQuoteRepository>((ref) {
  return QuoteRepositoryImpl(ref.watch(quoteRemoteDataSourceProvider));
});

final getQuotesUseCaseProvider = Provider<GetQuotesUseCase>((ref) {
  return GetQuotesUseCase(ref.watch(quoteRepositoryProvider));
});

final quotesProvider = FutureProvider<List<Quote>>((ref) async {
  return ref.watch(getQuotesUseCaseProvider).execute();
});



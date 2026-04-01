import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quote_model.dart';

abstract class QuoteRemoteDataSource {
  Future<List<QuoteModel>> fetchQuotes();
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  final SupabaseClient client;

  QuoteRemoteDataSourceImpl(this.client);

  @override
  Future<List<QuoteModel>> fetchQuotes() async {
    try {
      final response = await client
          .from('quotes')
          .select()
          .eq('is_active', true);

      final list = response as List;

      if (list.isEmpty) {
        return [];
      }

      return list.map((json) => QuoteModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch quotes: $e');
    }
  }
}

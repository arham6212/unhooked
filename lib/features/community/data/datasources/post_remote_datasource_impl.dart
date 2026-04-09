import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> fetchPosts();
  Future<void> createPost({String? title, required String body});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final SupabaseClient client;

  PostRemoteDataSourceImpl(this.client);

  @override
  Future<List<PostModel>> fetchPosts() async {
    try {
      final response = await client
          .from('posts')
          .select()
          .eq('is_deleted', false)
          .order('created_at', ascending: false)
          .limit(30);

      final list = response as List;

      if (list.isEmpty) {
        return [];
      }

      return list.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  @override
  Future<void> createPost({String? title, required String body}) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) throw Exception('Not authenticated');

      await client.from('posts').insert({
        'user_id': userId,
        if (title != null && title.isNotEmpty) 'title': title,
        'body': body,
      });
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }
}

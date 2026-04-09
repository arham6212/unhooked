import '../entities/post.dart';

abstract class IPostRepository {
  Future<List<Post>> getPosts();
  Future<void> createPost({String? title, required String body});
}

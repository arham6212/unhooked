import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPostsUseCase {
  final IPostRepository _repository;

  GetPostsUseCase(this._repository);

  Future<List<Post>> execute() {
    return _repository.getPosts();
  }
}

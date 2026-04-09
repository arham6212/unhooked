import '../repositories/post_repository.dart';

class CreatePostUseCase {
  final IPostRepository _repository;

  CreatePostUseCase(this._repository);

  Future<void> execute({String? title, required String body}) {
    return _repository.createPost(title: title, body: body);
  }
}

import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource_impl.dart';

class PostRepositoryImpl implements IPostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Post>> getPosts() async {
    return await remoteDataSource.fetchPosts();
  }

  @override
  Future<void> createPost({String? title, required String body}) async {
    return await remoteDataSource.createPost(title: title, body: body);
  }
}

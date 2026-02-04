import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Result<AuthUser>> signInWithGoogle() async {
    try {
      final userModel = await remoteDataSource.signInWithGoogle();
      if (userModel != null) {
        return Result.success(userModel);
      }
      return const Result.failure(AuthFailure('Google Sign-In failed.'));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> checkAuthStatus() async {
    try {
      // With Supabase, we can check the remote data source (SDK) for current session
      final isLoggedIn = Supabase.instance.client.auth.currentSession != null;
      return Result.success(isLoggedIn);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }
}


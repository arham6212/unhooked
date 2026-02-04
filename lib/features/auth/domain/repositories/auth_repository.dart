import '../../../../core/error/result.dart';
import '../entities/auth_user.dart';

abstract class IAuthRepository {
  Future<Result<AuthUser>> login(String email, String password);
  Future<Result<AuthUser>> signUp(String email, String password);
  Future<Result<AuthUser>> signInWithGoogle();
  Future<Result<void>> logout();
  Future<Result<bool>> checkAuthStatus();
}

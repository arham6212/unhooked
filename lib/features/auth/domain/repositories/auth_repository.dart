import '../../../../core/error/result.dart';
import '../entities/auth_user.dart';

abstract class IAuthRepository {
  Future<Result<AuthUser>> signInWithGoogle();
  Future<Result<void>> logout();
  Future<Result<bool>> checkAuthStatus();
}

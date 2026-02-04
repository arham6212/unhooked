import '../../../../core/error/result.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final IAuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  Future<Result<AuthUser>> execute() {
    return _repository.signInWithGoogle();
  }
}

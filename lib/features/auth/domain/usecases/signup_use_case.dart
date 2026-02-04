import '../../../../core/error/result.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final IAuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Result<AuthUser>> execute(String email, String password) {
    return _repository.signUp(email, password);
  }
}

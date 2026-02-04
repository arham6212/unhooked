import '../../../../core/error/result.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final IAuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Result<AuthUser>> execute(String email, String password) {
    return _repository.login(email, password);
  }
}

import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final IAuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Result<void>> execute() {
    return _repository.logout();
  }
}

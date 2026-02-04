import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final IAuthRepository _repository;

  CheckAuthStatusUseCase(this._repository);

  Future<Result<bool>> execute() {
    return _repository.checkAuthStatus();
  }
}

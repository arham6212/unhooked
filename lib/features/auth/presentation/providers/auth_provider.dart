import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_auth_status_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/signin_with_google_use_case.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';


final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});


final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});




final signInWithGoogleUseCaseProvider = Provider<SignInWithGoogleUseCase>((ref) {
  return SignInWithGoogleUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final checkAuthStatusUseCaseProvider = Provider<CheckAuthStatusUseCase>((ref) {
  return CheckAuthStatusUseCase(ref.watch(authRepositoryProvider));
});


final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

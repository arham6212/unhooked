import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/app_config.dart';
import '../models/auth_user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<AuthUserModel?> signInWithGoogle();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final _supabase = Supabase.instance.client;

  @override
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }



  @override
  Future<AuthUserModel?> signInWithGoogle() async {
    await gsi.GoogleSignIn.instance.initialize(
      clientId: AppConfig.googleAndroidClientId,
      serverClientId: AppConfig.googleWebClientId,
    );
    
    final googleUser = await gsi.GoogleSignIn.instance.authenticate();
    
    // In 7.x, account.authentication is synchronous
    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw const AuthException('No ID Token found.');
    }

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      // accessToken is optional for Google in many cases, or can be fetched via authorizationClient if needed
    );

    if (response.user != null) {
      return AuthUserModel(
        id: response.user!.id,
        email: response.user!.email ?? '',
      );
    }
    return null;
  }
}

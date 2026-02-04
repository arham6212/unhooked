import 'package:shared_preferences/shared_preferences.dart';

abstract class IAuthLocalDataSource {
  Future<void> persistToken(String token);
  Future<String?> getToken();
  Future<void> clear();
}

class AuthLocalDataSourceImpl implements IAuthLocalDataSource {
  static const String _tokenKey = 'auth_token';

  @override
  Future<void> persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

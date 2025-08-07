import 'package:flutter_secure_storage/flutter_secure_storage.dart';
abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;
  static const _tokenKey = 'auth_token';

  AuthLocalDataSourceImpl(this.storage);

  @override
  Future<void> cacheToken(String token) async {
    await storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getCachedToken() async {
    return await storage.read(key: _tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await storage.delete(key: _tokenKey);
  }
}

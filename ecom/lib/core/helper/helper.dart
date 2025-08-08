import 'package:jwt_decode/jwt_decode.dart';

class UserInfo {
  final String? userId;
  final String? email;
  final String? name;

  UserInfo({this.userId, this.email, this.name});
}

UserInfo extractUserInfo(String accessToken) {
  final payload = Jwt.parseJwt(accessToken);

  return UserInfo(
    userId: payload['sub'] as String?,
    email: payload['email'] as String?,
    name: payload['name'] as String?, // may be null if not present
  );
}


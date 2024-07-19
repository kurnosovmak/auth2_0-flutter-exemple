import 'dart:ffi';

import '../entities/auth.dart';

abstract class AuthRepository {
  Future<Auth> authenticate();
  Future<void> logout();
  Future<Auth> refreshToken(String refreshToken);
}

import 'dart:convert';
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

import '../entities/auth.dart';
import '../repositories/auth_repository.dart';

class Authenticate {
  final AuthRepository repository;

  Authenticate(this.repository);

  Auth? _auth = null;

  Future<Auth> call() async {
    final auth = await repository.authenticate();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth', jsonEncode(auth));
    _auth = auth;

    return auth;
  }

  Future<void> logout() async {
    // await repository.logout();

    final prefs = await SharedPreferences.getInstance();
    final isWrite = await prefs.remove('auth');

  }

  Future<Auth> refresh() async {
    final auth = await repository.refreshToken(_auth!.refreshToken);

    final prefs = await SharedPreferences.getInstance();
    final isWrite = await prefs.setString('auth', jsonEncode(auth));
    print(isWrite ? "good" : 'not');

    return auth;
  }

  Future<Auth?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonAuth = prefs.getString('auth');
    if (jsonAuth == null) {
      return null;
    }
    final auth = Auth.fromJson(jsonDecode(jsonAuth));
    _auth = auth;
    return auth;
  }

  Auth getTokenNotAsync() {
    return _auth!;
  }
}

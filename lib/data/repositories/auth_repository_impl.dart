import 'dart:async';
import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import '../../domain/entities/auth.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl implements AuthRepository {
  final authorizationEndpoint =
      'http://192.168.0.156:8080/oauth/authorize?client_id=3&redirect_uri=donation://&response_type=code&scope=*&state=23&prompt=login';
  final callbackUrlScheme = 'donation';

  final http.Client httpClient;

  Auth? _auth;

  AuthRepositoryImpl(this.httpClient);

  @override
  Future<Auth> authenticate() async {
// Present the dialog to the user
    final resultUrl = await FlutterWebAuth2.authenticate(
        url: authorizationEndpoint, callbackUrlScheme: callbackUrlScheme);

    final code = Uri.parse(resultUrl).queryParameters['code'] ?? '';
    final response = await httpClient.post(
        Uri.parse('http://192.168.0.156:8080/oauth/token'),
        body: <String, String>{
          'code': code,
          'redirect_uri': 'donation://',
          'grant_type': 'authorization_code',
          'client_id': "3",
          'client_secret': 'PsULx5VjVY7XHyTYKAcEyngz6TND29xapEk9TTkG',
          'scope': '*',
        });


    if (response.statusCode != 200) {
      throw Exception('Authorization failed');
    }
    final accessToken =
        jsonDecode(response.body)['access_token'];
    final refreshToken =
        jsonDecode(response.body)['refresh_token'];

    _auth = Auth(accessToken: accessToken, refreshToken: refreshToken);
    return _auth!;
  }

  @override
  Future<Auth> refreshToken(String refresh) async {
    if (_auth != null) {
      final response = await httpClient.post(
          Uri.parse('http://192.168.0.156:8080/oauth/token'),
          body: <String, String>{
            'refresh_token': refresh,
            'grant_type': 'refresh_token',
            'client_id': '3',
            'client_secret': 'PsULx5VjVY7XHyTYKAcEyngz6TND29xapEk9TTkG',
            'scope': '*',
          });
      if (response.statusCode != 200) {
        throw Exception('Authorization failed');
      }
      final accessToken =
          jsonDecode(response.body)['data']['token']['access_token'];
      final refreshToken =
          jsonDecode(response.body)['data']['token']['refresh_token'];

      _auth = Auth(accessToken: accessToken, refreshToken: refreshToken);
      return _auth!;
    }
    throw Exception('User not auth(refresh)');
  }

  @override
  Future<void> logout() {
    return Future(() => null);
  }
}

import 'package:get_it/get_it.dart';
import 'package:lentach/data/repositories/auth_repository_impl.dart';
import 'package:lentach/data/repositories/channel_repository_impl.dart';
import 'package:lentach/domain/usecases/authenticate.dart';
import 'package:http/http.dart' as http;
import 'package:lentach/domain/usecases/channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

void init() {
  // Repositories
  final authRepo = AuthRepositoryImpl(AuthInterceptor(http.Client()));
  final channelRepo = ChannelRepositoryImpl(AuthInterceptor(http.Client()));
  sl.registerLazySingleton<AuthRepositoryImpl>(
          () => authRepo);

  sl.registerLazySingleton<ChannelRepositoryImpl>(
          () => channelRepo);

  // Use cases

  sl.registerLazySingleton<Authenticate>(() => Authenticate(authRepo));
  sl.registerLazySingleton<GetChannels>(() => GetChannels(channelRepo));
}

class AuthInterceptor extends http.BaseClient {
  final http.Client _inner;

  AuthInterceptor(this._inner);

  Future<String?> _getToken() async {
    final token = await sl<Authenticate>().getToken();
    if (token == null) {
      return null;
    }
    return token.accessToken;
  }

  Future<String?> _getRefreshToken() async {
    final token = await sl<Authenticate>().getToken();
    if (token == null) {
      return null;
    }
    return token.refreshToken;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    final response = await _inner.send(request);
    if (response.statusCode != 401) {
      return response;
    }
    await sl<Authenticate>().refresh();
    final newToken = await _getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $newToken';
    }
    return await _inner.send(request);
  }
}

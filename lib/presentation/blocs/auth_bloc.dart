import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/authenticate.dart';
import '../../domain/entities/auth.dart';

abstract class AuthEvent {}

class AuthenticateEvent extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final Auth auth;

  Authenticated(this.auth);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Authenticate authenticate;

  AuthBloc(this.authenticate) : super(AuthInitial()) {
    on<AuthenticateEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final auth = await authenticate();
        emit(Authenticated(auth));
      } catch (e) {
        emit(AuthError('ошибка аунтификации ' + e.toString()));
      }
    });
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/auth_bloc.dart';
import '../../domain/usecases/authenticate.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:lentach/injection_container.dart' as di;

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) =>
            AuthBloc(di.sl<Authenticate>()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Авторизация'),
          ),
          body: Center(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthInitial) {
                  return ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(AuthenticateEvent());
                    },
                    child: const Text('Войти'),
                  );
                } else if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                } else if (state is Authenticated) {
                  Future.delayed(Duration.zero, () async {
                    Navigator.of(context, rootNavigator: true).pushReplacementNamed("/home");
                  });
                } else if (state is AuthError) {
                  return SizedBox.expand(
                    child: Center(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(AuthenticateEvent());
                            },
                            child: Text('Войти'),
                          ),
                          Text('Ошибка: ${state.message}'),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}

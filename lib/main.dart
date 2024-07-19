import 'package:flutter/material.dart';
import 'package:lentach/presentation/pages/channels/channel_page.dart';
import 'package:lentach/presentation/pages/main_page.dart';
import 'package:lentach/presentation/pages/start_page.dart';
import 'presentation/pages/auth_page.dart';
import 'package:lentach/injection_container.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define the initial route
      initialRoute: '/',
      // Define all the routes
      routes: {
        '/': (context) => const StartPage(),
        '/auth': (context) => const AuthPage(),
        '/home': (context) => MainScreen(),
      },
    );
  }
}

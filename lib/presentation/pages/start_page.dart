import 'package:flutter/material.dart';
import 'package:lentach/domain/usecases/authenticate.dart';
import 'package:lentach/injection_container.dart' as di;

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: FutureBuilder(
                future: di.sl<Authenticate>().getToken(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    Future.delayed(Duration.zero, () async {
                      await Navigator.of(context, rootNavigator: true).pushReplacementNamed("/home");
                    });
                  } else {
                    Future.delayed(Duration.zero, () async {
                      await Navigator.of(context, rootNavigator: true).pushReplacementNamed("/auth");
                    });
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
        )

        );
  }
}

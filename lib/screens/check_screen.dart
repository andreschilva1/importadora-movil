import 'package:flutter/material.dart';
import 'package:projectsw2_movil/screens/screens.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:provider/provider.dart';


class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.checkAuth(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                Future.microtask(() async {
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HomeScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                    );
                  }
                });
                return Container();
              } else {
                return const LoginScreen();
              }
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

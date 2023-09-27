import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'checkAuth';

  static final routes = <Ruta>[
    Ruta(name: 'Home', icon: Icons.home, route: 'home', screen: const HomeScreen()),
    Ruta(name: 'Perfil', icon: Icons.person, route: 'perfil', screen: const PerfilScreen()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll({'checkAuth': (context) => const CheckAuthScreen()});
    appRoutes.addAll({'login': (context) => const LoginScreen()});
    for (var element in routes) {
      appRoutes.addAll({element.route: (context) => element.screen});
    }
    return appRoutes;
  }
}

import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'checkAuth';

  static final routes = <Ruta>[
    Ruta(route: 'login', screen: const LoginScreen()),
    Ruta(route: 'home', screen: const HomeScreen()),
    Ruta(route: 'checkAuth', screen: const CheckAuthScreen()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    for (var element in routes) {
      appRoutes.addAll({element.route: (context) => element.screen});
    }
    return appRoutes;
  }
}

import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/screens/employee/employee.dart';
import 'package:projectsw2_movil/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'checkAuth';

  static final routes = <Ruta>[
    Ruta(name: 'Home', icon: Icons.home, route: 'home', screen: const HomeScreen()),
    Ruta(name: 'Perfil', icon: Icons.person, route: 'perfil', screen: const PerfilScreen()),
    Ruta(name: 'Almacén', icon: Icons.warehouse_rounded, route: 'warehouse', screen: const WarehouseScreen()),
    Ruta(name: 'Empleados', icon: Icons.person_2_outlined, route: 'empleado', screen: const EmployeeScreen()),
    Ruta(name: 'Registrar Paquetes', icon: Icons.add_box_outlined, route: 'resgistrarPaquete', screen: const CreatePaqueteScreen()),
    
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

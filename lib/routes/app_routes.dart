import 'package:flutter/material.dart';
import 'package:projectsw2_movil/screens/calculadora/calculadora_screen.dart';
import 'package:projectsw2_movil/screens/employee/employee_screen.dart';
import 'package:projectsw2_movil/screens/envio/seguimiento_screen.dart';
import 'package:projectsw2_movil/screens/metodoEnvio/metodo_envio_screen.dart';
import 'package:projectsw2_movil/screens/rastreo/rastreo_screen.dart';
import 'package:projectsw2_movil/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'checkAuth';

  static final routes = <RouteDefinition>[
    const RouteDefinition('Home', Icons.home, 'home', HomeScreen()),
    const RouteDefinition('Almacén', Icons.warehouse_rounded, 'warehouse', WarehouseScreen()),
    const RouteDefinition('Empleados', Icons.person_2_outlined, 'empleado', EmployeeScreen()),
    const RouteDefinition('MetodoEnvio', Icons.local_shipping_outlined, 'metodoEnvio', MetodoEnvioScreen()),
    const RouteDefinition('Paquete', Icons.add_box_outlined, 'paquete', PaqueteScreen()),
  ];

  static final routesCliente = <RouteDefinition>[
    const RouteDefinition('Home', Icons.home, 'home', HomeScreen()),
    const RouteDefinition('Paquete', Icons.add_box_outlined, 'paquete', PaqueteScreen()),
    const RouteDefinition('Rastreo de Paquetes', Icons.radar, 'rastreo', RastreoScreen()),
    const RouteDefinition('Calculadora de peso', Icons.calculate, 'calculadora', CalculadoraScreen()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes(BuildContext context){
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll({'checkAuth': (context) => const CheckAuthScreen()});
    appRoutes.addAll({'login': (context) => const LoginScreen()});
    for (var element in routes) {
      appRoutes.addAll({element.route: (context) => element.screen});
    }
    for (var element in routesCliente) {
      appRoutes.addAll({element.route: (context) => element.screen});
    }
    
    return appRoutes;
  }
}

class RouteDefinition {
  final String name;
  final IconData icon;
  final String route;
  final Widget screen;

  const RouteDefinition(this.name, this.icon, this.route, this.screen);
}
import 'package:flutter/material.dart';
import 'package:projectsw2_movil/screens/calculadora/calculadora_screen.dart';
import 'package:projectsw2_movil/screens/rastreo/rastreo_screen.dart';
import 'package:projectsw2_movil/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'checkAuth';

  static final allRoutes = <RouteDefinition>[
    const RouteDefinition('Perfil', Icons.home, 'home', HomeScreen()),
    const RouteDefinition('Almacenes', Icons.warehouse_rounded, 'warehouse', WarehouseScreen()),
    const RouteDefinition('Empleados', Icons.person_2_outlined, 'empleado', EmployeeScreen()),
    const RouteDefinition('Metodos de Envio', Icons.local_shipping_outlined, 'metodoEnvio', MetodoEnvioScreen()),
    const RouteDefinition('Paquetes', Icons.add_box_outlined, 'paquete', PaqueteScreen()),
    const RouteDefinition('Rastreo de Paquetes', Icons.radar, 'rastreo', RastreoScreen()),
    const RouteDefinition('Calculadora de Envio', Icons.calculate, 'calculadora', CalculadoraScreen()),
  ];

  static final routesCliente = <RouteDefinition>[
    const RouteDefinition('Perfil', Icons.home, 'home', HomeScreen()),
    const RouteDefinition('Paquetes', Icons.add_box_outlined, 'paquete', PaqueteScreen()),
    const RouteDefinition('Rastreo de Paquetes', Icons.radar, 'rastreo', RastreoScreen()),
    const RouteDefinition('Calculadora de Envio', Icons.calculate, 'calculadora', CalculadoraScreen()),
  ];

   static final routesAdministrativo = <RouteDefinition>[
    const RouteDefinition('Perfil', Icons.home, 'home', HomeScreen()),
    const RouteDefinition('Almacenes', Icons.warehouse_rounded, 'warehouse', WarehouseScreen()),
    const RouteDefinition('Empleados', Icons.person_2_outlined, 'empleado', EmployeeScreen()),
    const RouteDefinition('Metodos de Envio', Icons.local_shipping_outlined, 'metodoEnvio', MetodoEnvioScreen()),
  ];

   static final routesEncargadoAlmacen = <RouteDefinition>[
    const RouteDefinition('Perfil', Icons.home, 'home', HomeScreen()),
    const RouteDefinition('Paquetes', Icons.add_box_outlined, 'paquete', PaqueteScreen()),
  ];

   static final routesEncargadoEnvio = <RouteDefinition>[
    const RouteDefinition('Perfil', Icons.home, 'home', HomeScreen()),
    const RouteDefinition('Paquetes', Icons.add_box_outlined, 'paquete', PaqueteScreen()),
  ];

   static final routesEncargadoCompra = <RouteDefinition>[
    const RouteDefinition('Perfil', Icons.home, 'home', HomeScreen()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes(BuildContext context){
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll({'checkAuth': (context) => const CheckAuthScreen()});
    appRoutes.addAll({'login': (context) => const LoginScreen()});
    for (var element in allRoutes) {
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
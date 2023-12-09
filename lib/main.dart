import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:projectsw2_movil/routes/app_routes.dart';
import 'package:projectsw2_movil/services/envio_service.dart';
import 'package:projectsw2_movil/services/estado_envio_service.dart';
import 'package:projectsw2_movil/services/pais_services.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51O7Ie0AY23p6KhXHNTj81exQIqEtJQzgw3bmbdUscTh5UQmBZ7kdgwCG7920vd1ML6Xk3Yl2QcH1NAD1wTzVPdfO00UdyppfnW";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => WarehouseService()),
        ChangeNotifierProvider(create: (_) => EmployeeService()),
        ChangeNotifierProvider(create: (_) => MetodoEnvioService()),
        ChangeNotifierProvider(create: (_) => PaqueteService()),
        ChangeNotifierProvider(create: (_) => EnvioService()),
        ChangeNotifierProvider(create: (_) => PaisService()),
        ChangeNotifierProvider(create: (_) => EstadoEnvioService()),
        ChangeNotifierProvider(create: (_) => TrakingService()),  
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.getAppRoutes(context),
      theme: AppTheme.lightTheme,
    );
  }
}

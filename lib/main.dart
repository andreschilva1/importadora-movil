import 'package:flutter/material.dart';
import 'package:projectsw2_movil/routes/app_routes.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),      
        ], 
      child:const MyApp(),
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
      routes: AppRoutes.getAppRoutes(),
      theme: AppTheme.lightTheme,
    );
  }
}
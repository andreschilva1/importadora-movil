import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:projectsw2_movil/models/push_message.dart';
import 'package:projectsw2_movil/routes/app_routes.dart';
import 'package:projectsw2_movil/screens/envio/envio_screen.dart';
import 'package:projectsw2_movil/services/notification_service.dart';
import 'package:projectsw2_movil/services/pais_services.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51O7Ie0AY23p6KhXHNTj81exQIqEtJQzgw3bmbdUscTh5UQmBZ7kdgwCG7920vd1ML6Xk3Yl2QcH1NAD1wTzVPdfO00UdyppfnW";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';

  FirebaseMessaging.onBackgroundMessage(NotificationService.firebaseMessagingBackgroundHandler);
  await NotificationService.initializeFirebaseNotification();
  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  NotificationService notificationService = NotificationService(flutterLocalNotificationsPlugin);
  notificationService.notificationListener();
  await notificationService.requestPermission();

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

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

       if (message.notification == null) return;
      final notification = PushMessage(
        messageId: message.messageId?.replaceAll(':','').replaceAll('%','') ?? '',
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
        sentDate: message.sentTime ?? DateTime.now(),
        data: message.data,
        imageUrl: Platform.isAndroid 
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl, 
      );

      dynamic type = notification.data?['type'];
      if(type == 'registro-paquete')
      {
        navigatorKey.currentState?.pushNamed('paquete');
      }
      if (type == 'estado-envio') {
        debugPrint(notification.data?['paquete_id']);
        navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => EnvioScreen(paquete: int.parse(notification.data?['paquete_id']), peso: notification.data?['peso'])));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Your App Name',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey ,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.getAppRoutes(context),
      theme: AppTheme.lightTheme,
    );
  }
}

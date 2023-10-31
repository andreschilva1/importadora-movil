import 'package:flutter/material.dart';
import 'package:projectsw2_movil/routes/app_routes.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/theme/app_theme.dart';
import 'package:provider/provider.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: ListView(
        // Important: Remove any padding from the ListView.
        children: user!.rol == "Cliente"
            ? [
                Container(
                  padding: const EdgeInsets.all(10),
                  color: AppTheme.primaryColor,
                  child: const DrawerHeader(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('Assets/logo_campos_blanco.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(''),
                  ),
                ),
                ...AppRoutes.routesCliente.map(
                  (ruta) => ListTile(
                    leading: Icon(ruta.icon),
                    title: Text(ruta.name),
                    onTap: () {
                      Navigator.pushNamed(context, ruta.route);
                    },
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: const Icon(color: Colors.red, Icons.logout),
                  title: const Text('Cerrar Sesión'),
                  onTap: () async {
                    await authService.logout();
                    if (context.mounted) {
                      Navigator.pushNamed(context, 'login');
                    }
                  },
                ),
              ]
            : [
                Container(
                  padding: const EdgeInsets.all(10),
                  color: AppTheme.primaryColor,
                  child: const DrawerHeader(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('Assets/logo_campos_blanco.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(''),
                  ),
                ),
                ...AppRoutes.routes.map(
                  (ruta) => ListTile(
                    leading: Icon(ruta.icon),
                    title: Text(ruta.name),
                    onTap: () {
                      Navigator.pushNamed(context, ruta.route);
                    },
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: const Icon(color: Colors.red, Icons.logout),
                  title: const Text('Cerrar Sesión'),
                  onTap: () async {
                    await authService.logout();
                    if (context.mounted) {
                      Navigator.pushNamed(context, 'login');
                    }
                  },
                ),
              ],
      ),
    );
  }
}

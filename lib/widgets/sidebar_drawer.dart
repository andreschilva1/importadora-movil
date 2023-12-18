import 'package:flutter/material.dart';
import 'package:projectsw2_movil/routes/app_routes.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:projectsw2_movil/helpers/alert.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child:
          ListView(children: _getDrawerItems(context, authService, user!.rol)),
    );
  }

  List<Widget> _getDrawerItems(
      BuildContext context, AuthService authService, String rol) {
    switch (rol) {
      case "Cliente":
        return _getListaDerutas(
          context: context,
          authService: authService,
          routes: AppRoutes.routesCliente,
        );
      case "Personal Administrativo":
        return _getListaDerutas(
          context: context,
          authService: authService,
          routes: AppRoutes.routesAdministrativo,
        );
      case "Encargado de Almacen":
        return _getListaDerutas(
          context: context,
          authService: authService,
          routes: AppRoutes.routesEncargadoAlmacen,
        );
      case "Encargado de Envio":
        return _getListaDerutas(
          context: context,
          authService: authService,
          routes: AppRoutes.routesEncargadoEnvio,
        );
      case "Encargado de compra":
        return _getListaDerutas(
          context: context,
          authService: authService,
          routes: AppRoutes.routesEncargadoCompra,
        );
      default:
        return [
          Container(),
        ];
    }
  }

  List<Widget> _getListaDerutas(
      {required BuildContext context,
      required AuthService authService,
      required List<RouteDefinition> routes}) {
    return [
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
      ...routes.map(
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
          if (context.mounted) {
            showDialogCerrarSesion(context, authService);
          }
        },
      ),
    ];
  }
}

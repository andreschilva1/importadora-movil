import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/screens/paquete/create_consolidate_screen.dart';
import 'package:projectsw2_movil/screens/paquete/edit_consolidate_screen.dart';
import 'package:projectsw2_movil/screens/paquete/registrar_consolidate_screen.dart';
import 'package:projectsw2_movil/screens/screens.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PaqueteScreen extends StatelessWidget {
  const PaqueteScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Provider.of<PaqueteService>(context, listen: false).fetchPaquetes();
   AuthService authService = Provider.of<AuthService>(context, listen: false);
   User user = authService.user!;
   String rol = user.rol;
    Widget getActionButton() {
      if (rol == "Encargado de Almacen") {
        return IconButton(
          icon: const Icon(
            Icons.playlist_add_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatePaqueteScreen(),
              ),
            );
          },
        );
      } else if (rol == "Cliente") {
        return IconButton(
          icon: const Icon(
            Icons.inventory,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateConsolidateScreen(),
              ),
            );
          },
        );
      } else {
        return const SizedBox();
      }
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const SidebarDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              const Tab(text: "Sin Enviar"),
              (rol != 'Encargado de Envio')
                  ? const Tab(text: "Consolidados")
                  : const SizedBox(),
              (rol != 'Encargado de Almacen')
                  ? const Tab(text: "Enviados")
                  : const SizedBox(),
            ],
          ),
          actions: [
            getActionButton(),
          ],
          title: const Center(child: Text('Paquetes')),
        ),
        body: Center(
          child: TabBarView(
            children: [
              Consumer<PaqueteService>(
                builder: (context, paqueteProvider, child) {
                  if (paqueteProvider.paquetesSinEnviar!.isEmpty) {
                    return const Center(child: Text('No hay paquetes'));
                  }
                  List<Paquete> paquetesSinEnviar =
                      paqueteProvider.paquetesSinEnviar!;
                  return ListViewPaquetes(
                    user: user,
                    paquetes: paquetesSinEnviar,
                    textButtonEnvio: "Enviar",
                  );
                },
              ),
              (rol != 'Encargado de Envio')
                  ? Consumer<PaqueteService>(
                      builder: (context, paqueteProvider, child) {
                        if (paqueteProvider.paquetesConsolidados!.isEmpty) {
                          return const Center(
                              child: Text('No hay paquetes consolidados'));
                        }
                        List<Paquete> paquetesConsolidados =
                            paqueteProvider.paquetesConsolidados!;
                        return ListViewPaquetes(
                            user: user,
                            paquetes: paquetesConsolidados,
                            textButtonEnvio: "Enviar");
                      },
                    )
                  : const SizedBox(),
              (rol != 'Encargado de Almacen')
                  ? Consumer<PaqueteService>(
                      builder: (context, paqueteProvider, child) {
                        if (paqueteProvider.paquetesEnviados!.isEmpty) {
                          return const Center(
                              child: Text('No hay paquetes enviados'));
                        }
                        List<Paquete> paquetesEnviados =
                            paqueteProvider.paquetesEnviados!;
                        return ListViewPaquetes(
                            user: user,
                            paquetes: paquetesEnviados,
                            textButtonEnvio: "Ver Envio");
                      },
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ListViewPaquetes extends StatelessWidget {
  User user;
  List<Paquete> paquetes;
  String? textButtonEnvio;
  ListViewPaquetes(
      {Key? key,
      required this.user,
      required this.paquetes,
      this.textButtonEnvio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: paquetes.length,
      itemBuilder: (ctx, index) {
        Paquete paquete = paquetes[index];
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(children: [
                      paquete.photoPath != null
                          ? InkWell(
                              onTap: () async {
                                File file = await DefaultCacheManager()
                                    .getSingleFile(paquete.photoPath!);
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PaqueteZoomImageScreen(
                                              foto: file,
                                            )),
                                  );
                                }
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                margin: const EdgeInsets.only(
                                  right: 10,
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FadeInImage(
                                      placeholder: const AssetImage(
                                          'Assets/paquete.jpg'),
                                      image: NetworkImage(paquete.photoPath!),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            )
                          : const SizedBox(
                              width: 10,
                            ),
                      Flexible(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Id: ${paquete.id}",
                                style: TextStyle(color: Colors.black),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              paquete.codigo_rastreo != null
                                  ? Text(
                                      "Código de rastreo: ${paquete.codigo_rastreo}",
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      softWrap: true,
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Peso: ${paquete.peso} kg",
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                (paquete.consolidacion_estado_id != null)
                                    ? (paquete.consolidacion_estado_id == 2)
                                        ? "Estado Consolidacion: Terminado"
                                        : "Estado Consolidacion: En Consolidación"
                                    : "",
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ]),
                      )
                    ]),
                  ),
                  paquete.consolidacion_estado_id == 1
                      ? user.rol == "Cliente"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  InkWellParameters(
                                      text: "Editar",
                                      ancho: 0.30,
                                      color: Colors.orange,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditConsolidateScreen(
                                                      paqueteId: paquete.id,
                                                      almacen:
                                                          paquete.almacen_id)),
                                        );
                                      }),
                                ])
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  InkWellParameters(
                                      text: "Registrar",
                                      ancho: 0.30,
                                      color: Colors.orange,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrarConsolidateScreen(
                                                      paquete: paquete)),
                                        );
                                      }),
                                ])
                      : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(color: Color.fromARGB(125, 158, 158, 158)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWellParameters(
                      text: "Ver almacén",
                      ancho: 0.25,
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShowAlmacen(almacen: paquete.almacen_id)),
                        );
                      }),
                  const SizedBox(
                    width: 7,
                  ),
                  user.rol != "Cliente"
                      ? InkWellParameters(
                          text: "Cliente",
                          ancho: 0.25,
                          color: Colors.lightBlue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowCliente(
                                      empleado: paquete.cliente_id)),
                            );
                          })
                      : paquete.empleado_id != null
                          ? InkWellParameters(
                              text: "Empleado",
                              ancho: 0.25,
                              color: Colors.lightBlue,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowEmpleado(
                                          empleado: paquete.empleado_id!)),
                                );
                              })
                          : const SizedBox(),
                  const SizedBox(
                    width: 7,
                  ),
                  (paquete.consolidacion_estado_id == null ||
                          paquete.consolidacion_estado_id == 2)
                      ? InkWellParameters(
                          text: textButtonEnvio ?? "Enviar",
                          ancho: 0.25,
                          color: const Color.fromARGB(255, 244, 3, 152),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EnvioScreen(
                                      paquete: paquete.id, peso: paquete.peso)),
                            );
                          })
                      : const SizedBox(),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class InkWellParameters extends StatelessWidget {
  const InkWellParameters({
    super.key,
    required this.text,
    required this.color,
    required this.ancho,
    required this.onTap,
  });

  final String text;
  final Color color;
  final double ancho;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        width: MediaQuery.of(context).size.width * ancho,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

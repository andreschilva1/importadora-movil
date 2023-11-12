import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/paquete.dart';
import 'package:projectsw2_movil/screens/screens.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PaqueteScreen extends StatefulWidget {
  const PaqueteScreen({Key? key}) : super(key: key);

  @override
  State<PaqueteScreen> createState() => _PaqueteScreenState();
}

class _PaqueteScreenState extends State<PaqueteScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<PaqueteService>(context, listen: false).fetchPaquetes();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;
    return Scaffold(
      drawer: const SidebarDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.playlist_add_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreatePaqueteScreen()),
              );
            },
          ),
        ],
        title: const Text('Paquetes'),
      ),
      body: Center(
        child: Consumer<PaqueteService>(
            builder: (context, paqueteProvider, child) {
          if (paqueteProvider.paquetes!.isEmpty) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: paqueteProvider.paquetes!.length,
            itemBuilder: (ctx, index) {
              Paquete paquete = paqueteProvider.paquetes![index];
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
                            InkWell(
                              onTap: () async {
                                File file = await DefaultCacheManager()
                                    .getSingleFile(paquete.photoPath);
                                if (mounted) {   
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
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FadeInImage(
                                      placeholder:
                                          const AssetImage('Assets/caja.gif'),
                                      image: NetworkImage(paquete.photoPath),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(paquete.codigo_rastreo,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Peso: ${paquete.peso} kg",
                                        style:
                                            TextStyle(color: Colors.grey[500])),
                                  ]),
                            )
                          ]),
                        ),
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
                            color: Colors.green,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowAlmacen(
                                        almacen: paquete.almacen_id)),
                              );
                            }),
                        const SizedBox(
                          width: 7,
                        ),
                        user!.rol == "Cliente"
                            ? InkWellParameters(
                                text: "Empleado",
                                color: Colors.lightBlue,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowEmpleado(
                                            empleado: paquete.empleado_id)),
                                  );
                                })
                            : InkWellParameters(
                                text: "Cliente",
                                color: Colors.lightBlue,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowCliente(
                                            empleado: paquete.cliente_id)),
                                  );
                                }),
                        const SizedBox(
                          width: 7,
                        ),
                        InkWellParameters(
                            text: "Envío",
                            color: const Color.fromARGB(255, 244, 3, 152),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnvioScreen(
                                        paquete: paquete.id,
                                        peso: paquete.peso)),
                              );
                            }),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class InkWellParameters extends StatelessWidget {
  const InkWellParameters({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  final String text;
  final Color color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        // ancho máximo del 15% del ancho total de la pantalla
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

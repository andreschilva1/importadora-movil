import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/alert.dart';
import 'package:projectsw2_movil/models/envio.dart';
import 'package:projectsw2_movil/screens/screens.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EnvioScreen extends StatelessWidget {
  final int paquete;
  final String peso;

  const EnvioScreen({Key? key, required this.paquete, required this.peso})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false).user!;
    return Scaffold(
      drawer: const SidebarDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Envío'),
      ),
      body: Center(
        child: FutureBuilder<Envio?>(
          future: Provider.of<EnvioService>(context).getEnvio(paquete),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 43, 36, 67),
                                Color.fromARGB(255, 135, 110, 202)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 100,
                    left: 25,
                    right: 25,
                    bottom: 25,
                    child: Card(
                        elevation: 5,
                        child: Container(
                            padding: const EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width * .85,
                            height: authService.rol != "Cliente" ? 460 : 400,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Información",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey[300],
                                  ),
                                  RowCustom(
                                    icon: Icons.source,
                                    color: Colors.blueAccent[400]!,
                                    text: "Informacion de Rastreo",
                                    subText:snapshot.data!.codigoRastreo == null
                                            ? "Codigo no registrado"
                                            : snapshot.data!.codigoRastreo!,
                                    child: InkWell(
                                      onTap: () {
                                        if (snapshot.data!.codigoRastreo == null) {
                                          showBottomAlert(
                                              context: context,
                                              message:
                                                  "El envío no tiene un código de rastreo.",
                                              color: Colors.red);
                                          return;
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SeguimientoScreen(numeroRastreo: snapshot.data!.codigoRastreo!),
                                            )
                                        );
                                      },
                                      child: Icon(Icons.visibility_outlined,
                                          color: Colors.blueAccent.shade700,
                                          size: 30),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  RowCustom(
                                    icon: Icons.money_off,
                                    color: Colors.yellowAccent[400]!,
                                    text: "Costo",
                                    subText: "${snapshot.data!.costo} Bs",
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  RowCustom(
                                    icon: Icons.local_shipping,
                                    color: Colors.pinkAccent[400]!,
                                    text: "Transportista",
                                    subText: snapshot.data!.transportista,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  RowCustom(
                                    icon: Icons.airplane_ticket,
                                    color: Colors.black,
                                    text: "Método",
                                    subText: snapshot.data!.metodo,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  RowCustom(
                                    icon: Icons.sell,
                                    color: Colors.lightBlue,
                                    text: "Costo por Kg",
                                    subText: snapshot.data!.costoKg,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  RowCustom(
                                    icon: Icons.business,
                                    color: Colors.green,
                                    text: "Estado del Envío",
                                    subText: snapshot.data!.name,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  authService.rol != "Cliente"
                                      ? TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditEnvioScreen(
                                                        envio:
                                                            snapshot.data!.id,
                                                        codigo: snapshot.data!
                                                            .codigoRastreo,
                                                        metodo: snapshot.data!
                                                            .envioEstadoId,
                                                      )),
                                            );
                                          },
                                          child: const Text('Actualizar',
                                              style: TextStyle(
                                                  color: Colors.white)))
                                      : const SizedBox(),
                                ],
                              ),
                            ))),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              if (authService.rol == "Cliente") {
                return CreateEnvioScreen(peso: peso, paquete: paquete);
              } else {
                return Column(
                  children: [
                    CustomNotification(
                      title: "Error de Acceso",
                      message: "Su rol no le permite crear envíos.",
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra el aviso
                      },
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }
}



class CustomNotification extends StatelessWidget {
  final String title;
  final String message;
  final void Function() onPressed;

  const CustomNotification({
    super.key,
    required this.title,
    required this.message,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red, // Puedes personalizar el color de fondo
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.error,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const Spacer(), // Espacio para alinear el botón a la derecha
          TextButton(
            onPressed: onPressed,
            child: const Text(
              "Cerrar",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

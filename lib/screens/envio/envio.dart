import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/envio.dart';
import 'package:projectsw2_movil/screens/envio/edit_envio_screen.dart';
import 'package:projectsw2_movil/services/envio.service.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EnvioScreen extends StatefulWidget {
  final int paquete;
  const EnvioScreen({Key? key, required this.paquete}) : super(key: key);

  @override
  State<EnvioScreen> createState() => _EnvioScreenState();
}

class _EnvioScreenState extends State<EnvioScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarDrawer(),
      appBar: AppBar(
        // actions: user!.rol == "Cliente"
        //     ? []
        //     : [
        //         IconButton(
        //           icon: const Icon(
        //             Icons.edit_note_outlined,
        //             color: Colors.white,
        //           ),
        //           onPressed: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => const EditProfile()),
        //             );
        //           },
        //         ),
        //       ],
        centerTitle: true,
        title: const Text('Envío'),
      ),
      body: Center(
        child: FutureBuilder<Envio?>(
          future: Provider.of<EnvioService>(context).getEnvio(widget.paquete),
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
                  Card(
                      elevation: 5,
                      child: Container(
                          padding: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * .85,
                          height: 460,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                text: "Código de Rastreo", 
                                subText: snapshot.data!.codigoRastreo == null
                                  ? "No registrado"
                                  : snapshot.data!.codigoRastreo!,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              RowCustom(
                                icon: Icons.money_off,
                                color: Colors.yellowAccent[400]!, 
                                text: "Costo", 
                                subText: snapshot.data!.costo,
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
                                text: "Método del transportista", 
                                subText: snapshot.data!.metodo,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              RowCustom(
                                icon: Icons.sell,
                                color: Colors.lightBlue, 
                                text: "Costo por Kg del transportista", 
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
                              TextButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditEnvioScreen(envio: snapshot.data!.id, codigo: snapshot.data!.codigoRastreo, metodo: snapshot.data!.envioEstadoId,
                                        )),
                                  );
                                }, 
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 70, vertical: 10),
                                  child: const Text('Actualizar',
                                      style: TextStyle(color: Colors.white)))
                              )
                            ],
                          ))),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class RowCustom extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String subText;

  const RowCustom({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
    required this.subText
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: 35,
        ),
        const SizedBox(
          width: 20.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            Text(
              subText,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey[400],
              ),
            )
          ],
        )
      ],
    );
  }
}

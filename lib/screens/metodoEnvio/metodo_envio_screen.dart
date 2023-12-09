import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/alert.dart';
import 'package:projectsw2_movil/models/metodo_envio.dart';
import 'package:projectsw2_movil/screens/metodoEnvio/create_metodo_envio.dart';
import 'package:projectsw2_movil/services/metodo_envio_service.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MetodoEnvioScreen extends StatefulWidget {
  const MetodoEnvioScreen({Key? key}) : super(key: key);

  @override
  State<MetodoEnvioScreen> createState() => _MetodoEnvioScreenState();
}

class _MetodoEnvioScreenState extends State<MetodoEnvioScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MetodoEnvioService>(context, listen: false).fetchMetodoEnvios();
  }

  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => const CreateMetodoEnvioScreen()),
              );
            },
          ),
        ],
        title: const Text('Métodos de Envio'),
      ),
      body: Center(
        child: Consumer<MetodoEnvioService>(builder: (context, metodoEnvioProvider, child) {
          if (metodoEnvioProvider.metodoEnvios!.isEmpty) {
            return const CircularProgressIndicator();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height * .9,
            child: ListView.builder(
              itemCount: metodoEnvioProvider.metodoEnvios!.length,
              itemBuilder: (ctx, index) {
                MetodoEnvio metodoEnvio = metodoEnvioProvider.metodoEnvios![index];
                return Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                            Colors.white,
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3)
                          ])),
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 133, 119, 119)
                                          .withOpacity(0.3),
                                      spreadRadius: 1.2,
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.local_shipping_outlined,
                                  color: Color.fromARGB(255, 0, 73, 175),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: Text(
                                    "Transportista: ${metodoEnvio.transportista}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: Text(
                                    "Método: ${metodoEnvio.metodo}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: Text(
                                    "Costo por Kg: ${metodoEnvio.costoKg} bs",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: Text(
                                    "País: ${metodoEnvio.pais.name}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 5),
                                  child: Row(
                                    children: <Widget>[
                                      ElevatedButton.icon(
                                          onPressed: () {
                                            showAlertDialog(context, (){
                                              FocusScope.of(context).unfocus();
                                              Provider.of<MetodoEnvioService>(context, listen: false)
                                                  .eliminar(context, metodoEnvio.id);
                                            });
                                          },
                                          label: const Text('Eliminar'),
                                          icon: const Icon(Icons.delete),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red[700])),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 5),
                                  child: Row(
                                    children: <Widget>[
                                      ElevatedButton.icon(
                                          onPressed: () {
                                            // showAlertDialog(context, "Método de Envío", metodoEnvio.id);
                                          },
                                          label: const Text('Editar'),
                                          icon: const Icon(Icons.edit),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromARGB(255, 0, 76, 255))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}


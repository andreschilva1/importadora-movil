import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/alert.dart';
import 'package:projectsw2_movil/models/almacen.dart';
import 'package:projectsw2_movil/providers/warehouse_provider.dart';
import 'package:projectsw2_movil/screens/warehouse/create_warehouse.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class WarehouseScreen extends StatefulWidget {
  const WarehouseScreen({Key? key}) : super(key: key);

  @override
  State<WarehouseScreen> createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WarehouseProvider>(context, listen: false).fetchWarehouses();
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
                MaterialPageRoute(builder: (context) => const CreateWarehouseScreen()),
              );
            },
          ),
        ],
        title: const Text('Almacenes'),
      ),
      body: Center(
        child: Consumer<WarehouseProvider>(builder: (context, warehouseProvider, child) {
          if (warehouseProvider.almacenes!.isEmpty) {
            return const CircularProgressIndicator();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height * .9,
            child: ListView.builder(
              itemCount: warehouseProvider.almacenes!.length,
              itemBuilder: (ctx, index) {
                Almacen almacen = warehouseProvider.almacenes![index];
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
                                  Icons.warehouse,
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
                                    almacen.name,
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
                                    "Dirección: ${almacen.direccion}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: Text(
                                    "Teléfono: ${almacen.telefono}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: Text(
                                    "País: ${almacen.pais}",
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
                                            showAlertDialog(context, "Almacen", almacen.id);
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
                                            showAlertDialog(context, "Almacen", almacen.id);
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


import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/almacen.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:provider/provider.dart';

class ShowAlmacen extends StatefulWidget {
  final int almacen;
  const ShowAlmacen({super.key, required this.almacen});

  @override
  State<ShowAlmacen> createState() => _ShowAlmacenState();
}

class _ShowAlmacenState extends State<ShowAlmacen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Almacén", style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Almacen?>(
          future: Provider.of<WarehouseService>(context).getAlmacen(widget.almacen),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final almacen = snapshot.data;
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 190,
                    width: MediaQuery.of(context).size.width * .9,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("Assets/almacen2.jpg", fit: BoxFit.cover),
                        Container(
                          padding: const EdgeInsets.only(top: 100),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage("Assets/almacen.jpg"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      almacen!.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              "Dirección",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            subtitle: Text(
                              almacen.direccion,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          ListTile(
                            title: const Text(
                              "Teléfono",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            subtitle: Text(
                              almacen.telefono,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          ListTile(
                            title: const Text(
                              "País",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            subtitle: Text(
                              almacen.pais,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        ),
      ),
    );
  }
}

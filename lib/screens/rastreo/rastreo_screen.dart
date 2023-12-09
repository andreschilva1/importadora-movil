import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/rastreo.dart';
import 'package:projectsw2_movil/screens/screens.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RastreoScreen extends StatefulWidget {
  const RastreoScreen({Key? key}) : super(key: key);

  @override
  State<RastreoScreen> createState() => _RastreoScreenState();
}

class _RastreoScreenState extends State<RastreoScreen> {
  @override
  Widget build(BuildContext context) {
    TrakingService trakingService =
        Provider.of<TrakingService>(context);
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
                    builder: (context) => const CreateRastreoScreen()),
              );
            },
          ),
        ],
        title: const Text('Rastreo de Paquetes'),
      ),
      body: Center(
        child: FutureBuilder(
            future: trakingService.obtenerRastreos(),
            builder: (_, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                List<Rastreo> rastreos = snapshot.data;
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: rastreos.length,
                  itemBuilder: (ctx, index) {
                    Rastreo rastreo = rastreos[index];
                    return 

                    Card(
                      elevation: 2,
                      shadowColor: Colors.grey.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SeguimientoScreen(numeroRastreo: rastreo.codigoRastreo)),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),

                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 15),
                          
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(children: [
                                      SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child:
                                                Image.asset("Assets/paquete.jpg"),
                                          )),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(rastreo.codigoRastreo,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(rastreo.name,
                                                  style: TextStyle(
                                                      color: Colors.grey[500])),
                                            ]),
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Divider(
                                  color: Color.fromARGB(125, 158, 158, 158)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}

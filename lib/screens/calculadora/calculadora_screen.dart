import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/metodo_envio.dart';
import 'package:projectsw2_movil/services/metodo_envio_service.dart';

import 'package:provider/provider.dart';

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  bool showResult = false;
  final TextEditingController _controller = TextEditingController();
  int value = 1;

  @override
  void initState() {
    super.initState();
    Provider.of<MetodoEnvioService>(context, listen: false).fetchMetodoEnvios();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Calculadora de peso'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Ingrese el peso(kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showResult = true;
                    if (_controller.text.isEmpty || _controller.text == "0") {
                      value = 1;
                    }else{
                      value = int.parse(_controller.text);
                    }
                  });
                },
                child: const Text('Calcular'),
              ),
              const SizedBox(height: 10),
              !showResult
                  ? Container()
                  : Center(
                      child: Consumer<MetodoEnvioService>(
                          builder: (context, metodoEnvioProvider, child) {
                        if (metodoEnvioProvider.metodoEnvios!.isEmpty) {
                          return const CircularProgressIndicator();
                        }
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * .6,
                          child: ListView.builder(
                            itemCount: metodoEnvioProvider.metodoEnvios!.length,
                            itemBuilder: (ctx, index) {
                              MetodoEnvio metodoEnvio =
                                  metodoEnvioProvider.metodoEnvios![index];
                              return Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                          Colors.white,
                                          const Color.fromARGB(255, 0, 0, 0)
                                              .withOpacity(0.3)
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
                                            decoration: BoxDecoration(
                                              boxShadow: [BoxShadow(
                                                  color: const Color.fromARGB(
                                                          255, 133, 119, 119)
                                                      .withOpacity(0.3),
                                                  spreadRadius: 1.2,
                                                  blurRadius: 7,
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(5),
                                            child: const Icon(
                                              Icons.local_shipping_outlined,
                                              color: Color.fromARGB(
                                                  255, 0, 73, 175),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.42,
                                                child: Text(
                                                  "Transportista: ${metodoEnvio.transportista}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.42,
                                                child: Text(
                                                  "Método: ${metodoEnvio.metodo}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.42,
                                                child: Text(
                                                  "Costo Total ${int.parse(metodoEnvio.costoKg) * value} bs",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.42,
                                                child: Text(
                                                  "País: ${metodoEnvio.pais.name}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
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
            ],
          ),
        ),
      ),
    );
  }
}

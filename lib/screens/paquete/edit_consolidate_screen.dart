import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/card_container.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditConsolidateScreen extends StatefulWidget {
  final int paqueteId;
  final int almacen;
  const EditConsolidateScreen(
      {super.key, required this.paqueteId, required this.almacen});

  @override
  State<EditConsolidateScreen> createState() => _EditConsolidateScreenState();
}

class _EditConsolidateScreenState extends State<EditConsolidateScreen> {
  int peso = 0;
  List<int> listIds = [];
  List<Paquete> paquetes = [];
  List<int> selectedIndex = [];
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    actualizarPaquetes(widget.almacen);
  }

  Future<void> actualizarPaquetes(int almacenId) async {
    final paquetesAlmacen = await Provider.of<PaqueteService>(context, listen: false).getPaquetesAlmacenEditar(almacenId);

    setState(() {
      paquetes = paquetesAlmacen;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
    ? const Center(child: CircularProgressIndicator(color: Colors.black,),) 
    : Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text('Editando Consolidación'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(1),
                      scrollDirection: Axis.vertical,
                      primary: true,
                      shrinkWrap: false,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        mainAxisExtent: 110,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: paquetes.length,
                      itemBuilder: (context, index) {
                        Paquete paquete = paquetes[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedIndex.contains(index)) {
                                selectedIndex.remove(index);
                                listIds.remove(paquete.id);
                                peso = peso - int.parse(paquete.peso);
                              } else {
                                selectedIndex.add(index);
                                listIds.add(paquete.id);
                                peso = peso + int.parse(paquete.peso);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: selectedIndex.contains(index)
                                  ? const Color(0xffdfecea)
                                  : const Color(0xff394f4c),
                            ),
                            child: Column(
                              children: [
                                Image.asset('Assets/paquete.jpg',
                                    width: 40, height: 40),
                                Text(
                                  "peso: ${paquete.peso} kg",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: selectedIndex.contains(index)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "creado: ${convertirFechaALocal(paquete.createdAt!)}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: selectedIndex.contains(index)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        elevation: 0,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 15),
                            child: const Text('Editar',
                                style: TextStyle(color: Colors.white))),
                        onPressed: () {
                          Provider.of<PaqueteService>(context, listen: false)
                              .editConsolidacion(widget.paqueteId,
                                  peso.toString(), listIds, context);
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String convertirFechaALocal(String fechaHora) {
  DateTime fecha = DateTime.parse(fechaHora).toLocal();
  String fechaFormateada = DateFormat.yMd().add_jms().format(fecha);
  return fechaFormateada;
}

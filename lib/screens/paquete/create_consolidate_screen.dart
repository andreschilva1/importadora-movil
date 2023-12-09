import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/helpers.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/card_container.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateConsolidateScreen extends StatefulWidget {
  const CreateConsolidateScreen({super.key});

  @override
  State<CreateConsolidateScreen> createState() =>
      _CreateConsolidateScreenState();
}

class _CreateConsolidateScreenState extends State<CreateConsolidateScreen> {
  int peso = 0;
  String? almacenId;
  List<int> listIds = [];
  List<Paquete> paquetes = [];
  List<int> selectedIndex = [];

  Future<void> actualizarPaquetes(String almacenId) async {
    final paquetesAlmacen =
        await Provider.of<PaqueteService>(context, listen: false)
            .getPaquetesAlmacen(int.parse(almacenId));

    setState(() {
      paquetes = paquetesAlmacen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final warehouseService = Provider.of<WarehouseService>(context).almacenes;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
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
        title: const Text('Creando Consolidación'),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButtonFormField<String>(
                        decoration: InputDecorations.authInputDecoration(
                          hintText: 'Almacén',
                          labelText: 'Almacén de los paquetes',
                          prefixIcon: Icons.warehouse,
                        ),
                        value: almacenId,
                        onChanged: (value) {
                          setState(() {
                            almacenId = value;
                          });
                          actualizarPaquetes(almacenId!);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Debe elegir un almacén';
                          }
                          return null;
                        },
                        items: warehouseService!.map((almacen) {
                          return DropdownMenuItem<String>(
                            value: almacen.id.toString(),
                            child: Text(almacen.name),
                          );
                        }).toList()),
                    const SizedBox(height: 30),
                    paquetes.isNotEmpty
                        ? SizedBox(
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
                          )
                        : const Text(
                            "Selecciona un almacén para mostrar qué paquetes puedes consolidar",
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.black, 
                              fontSize: 20
                            ),
                            textAlign: TextAlign.center),
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
                              child: const Text('Crear',
                                  style: TextStyle(color: Colors.white))),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              Provider.of<PaqueteService>(context,
                                      listen: false)
                                  .crearConsolidacion(peso.toString(),
                                      int.parse(almacenId!), listIds, context);
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

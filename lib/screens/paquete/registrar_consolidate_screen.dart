import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectsw2_movil/helpers/helpers.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegistrarConsolidateScreen extends StatefulWidget {
  final Paquete paquete;
  const RegistrarConsolidateScreen({Key? key, required this.paquete})
      : super(key: key);

  @override
  State<RegistrarConsolidateScreen> createState() =>
      _RegistrarConsolidateScreenState();
}

class _RegistrarConsolidateScreenState
    extends State<RegistrarConsolidateScreen> {
  File? _imagenPaquete;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pesoController = TextEditingController();
  late PaqueteService _paqueteService;
  String _photoPath = '';
  List<Paquete> paquetes = [];
  bool isLoading = true;
  bool loading = true;
  int pesoTotal = 0;

  @override
  void initState() {
    super.initState();
    _paqueteService = Provider.of<PaqueteService>(context, listen: false);
    colocarPaquetes(widget.paquete.id);
  }

  Future<void> colocarPaquetes(int paqueteId) async {
    final paquetesAlmacen =
        await Provider.of<PaqueteService>(context, listen: false)
            .getPaquetesConsolidacion(paqueteId);

    setState(() {
      paquetes = paquetesAlmacen;
      loading = false;
      for (var paquete in paquetes) {
        int peso = int.parse(paquete.peso);
        pesoTotal += peso;
      }
    });
  }

  Future<void> procesarImagen() async {
    try {
      final imageUrl = await _paqueteService.subirImagen(
        imageFile: _imagenPaquete!,
        context: context,
      );
      _photoPath = imageUrl;
    } catch (e) {
      if (mounted) {
        showBottomAlert(
          context: context,
          message: 'Error al subir la imagen',
        );
      }
    }
  }

  Future<void> registrarPaquete() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      if (_imagenPaquete == null) {
        // Si no se ha seleccionado una _imagenPaquete, mostrar un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Seleccione una imagen para el Paquete'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Si se ha seleccionado una _imagenPaquete, proceder con la creación
        try {
          await _paqueteService.registrarConsolidacion(
            paqueteId: widget.paquete.id,
            photoPath: _photoPath,
            codigoRastreo: '',
            peso: _pesoController.text.trim(),
          );
          //navegar a la pantalla de home
          if (context.mounted) {
            Navigator.pop(context);
          }
        } catch (e) {
          if (mounted) {
            displayDialog(
              context,
              'Error al crear la persona desaparecida',
              e.toString(),
              Icons.error,
              Colors.red,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
    ? const Center(child: CircularProgressIndicator(color: Colors.black,),)
    : Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Registrar Consolidacion'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Paquetes de la consolidación", style: TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(height: 5,),
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
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color(0xffdfecea),
                        ),
                        child: Column(
                          children: [
                            Image.asset('Assets/paquete.jpg',
                                width: 40, height: 40),
                            Text(
                              "id: ${paquete.id} peso: ${paquete.peso} kg",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color:  Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "codigo: ${paquete.codigo_rastreo}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color:  Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                _buildPesoTextField(),
                const SizedBox(height: 30),
                _buildImagenPaquete(),
                const SizedBox(height: 30),
                _buildAgregarImagenButton(),
                const SizedBox(height: 30),
                _buildRegistrarButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPesoTextField() {
    return TextFormField(
      autocorrect: false,
      keyboardType: TextInputType.number,
      decoration: InputDecorations.authInputDecoration(
        hintText: 'Peso',
        labelText: 'Peso del paquete en Kg',
        prefixIcon: Icons.border_all,
      ),
      controller: _pesoController,
      onChanged: (value) => value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese el peso del paquete';
        }
        return null;
      },
    );
  }

  Widget _buildImagenPaquete() {
    if (_imagenPaquete != null) {
      return PaqueteImage(foto: _imagenPaquete!);
    }
    return Container();
  }

  Widget _buildAgregarImagenButton() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10),
              ),
            ),
            onPressed: () async {
              _imagenPaquete = await pickImageFromCamera();
              await procesarImagen();
              setState(() {
                
              });
            },
            child: const Icon(
              Icons.add_a_photo_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10),
              ),
            ),
            onPressed: () async {
              _imagenPaquete = await pickImageFromGallery();
              await procesarImagen();
              setState(() {
                
              });
            },
            child: const Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrarButton() {
    return Container(
      alignment: Alignment.center,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledColor: Colors.grey,
        elevation: 0,
        color: const Color.fromARGB(255, 0, 0, 0),
        onPressed: _paqueteService.isLoading
            ? null
            : () {
                registrarPaquete();
              },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
          child: _paqueteService.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Registrar',
                  style: TextStyle(color: Colors.white),
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

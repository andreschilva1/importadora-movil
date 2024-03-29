import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/helpers.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CreatePaqueteScreen extends StatefulWidget {
  const CreatePaqueteScreen({Key? key}) : super(key: key);

  @override
  State<CreatePaqueteScreen> createState() => _CreatePaqueteScreenState();
}

class _CreatePaqueteScreenState extends State<CreatePaqueteScreen> {
  File? _imagenPaquete;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codigoRastreoController =
      TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _numeroCasillero = TextEditingController();
  final TextEditingController _clienteEncontrado = TextEditingController();
  String _resultado = '';
  late PaqueteService _paqueteService;
  String _photoPath = '';
  String? _clienteId;

  @override
  void initState() {
    super.initState();
    _paqueteService = Provider.of<PaqueteService>(context, listen: false);
  }

  Future<void> buscarCliente(final casillero) async {
    _clienteEncontrado.clear();
    _resultado = '';
    if (casillero.length >= 5) {
      final cliente = await _paqueteService.getClienteDelPaquete(casillero);
      if (cliente != null) {
        _resultado = 'Cliente Encontrado';
        _clienteEncontrado.text = cliente['nombre'].toString();
        _clienteId = cliente['id'].toString();
      } else {
        _resultado = 'No se encontro el cliente';
      }
    }
    setState(() {});
  }

  Future<void> procesarImagen() async {
    try {
      final imageUrl = await _paqueteService.subirImagen(
        imageFile: _imagenPaquete!,
        context: context,
      );
      final data = await _paqueteService.obtenerDatosDeImagen(
        imageUrl: imageUrl,
        context: context,
      );
      _codigoRastreoController.text = data['numeroRastreo'];
      _numeroCasillero.text = data['casillero'];
      _photoPath = data['photoPath'];
      await buscarCliente(data['casillero']);
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
            content: Text('Seleccione una imagen del Paquete'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Si se ha seleccionado una _imagenPaquete, proceder con la creación
        try {
          await _paqueteService.createPaquete(
            photoPath: _photoPath,
            codigoRastreo: _codigoRastreoController.text.trim(),
            peso: _pesoController.text.trim(),
            clienteId: _clienteId,
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Registrar Paquete'),
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
                const Text(
                  'Sube una Imagen Para Escanear',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildAgregarImagenButton(),
                (_imagenPaquete != null)
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                _buildImagenPaquete(),
                const SizedBox(height: 20),
                _buildPesoTextField(),
                const SizedBox(height: 20),
                _buildBuscarClienteTextField(),
                const SizedBox(height: 20),
                _buildClienteEncontradoTextField(),
                const SizedBox(height: 20),
                _buildCodigoRastreoTextField(),
                const SizedBox(height: 20),
                _buildRegistrarButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodigoRastreoTextField() {
    return TextFormField(
      autocorrect: false,
      keyboardType: TextInputType.text,
      decoration: InputDecorations.authInputDecoration(
        hintText: 'Codigo de rastreo',
        labelText: 'Codigo de rastreo del paquete',
        prefixIcon: Icons.code,
      ),
      controller: _codigoRastreoController,
      onChanged: (value) => value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese el codigo de rastreo';
        }
        return null;
      },
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

  Widget _buildBuscarClienteTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Buscar Cliente por # Casillero',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          autocorrect: false,
          keyboardType: TextInputType.text,
          decoration: InputDecorations.authInputDecoration(
            hintText: '# Casillero',
            labelText: '# Casillero del Cliente',
            prefixIcon: Icons.search,
          ),
          controller: _numeroCasillero,
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 5) {
              return 'Ingrese el numero de casillero minimo 5 caracteres';
            }
            return null;
          },
          onChanged: (value) => buscarCliente(value),
        ),
      ],
    );
  }

  Widget _buildClienteEncontradoTextField() {
    return TextFormField(
      enabled: false,
      autocorrect: false,
      keyboardType: TextInputType.text,
      decoration: InputDecorations.authInputDecoration(
        hintText: 'Cliente',
        labelText: _resultado,
        prefixIcon: Icons.person_outlined,
        labelTextColor:
            (_resultado != 'Cliente Encontrado') ? Colors.red : Colors.black,
      ),
      style: const TextStyle(
        color: Colors.green,
      ),
      controller: _clienteEncontrado,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Debe Encontrar el cliente por su numero de casillero';
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
              procesarImagen();
            },
            child: const Icon(
              Icons.add_a_photo_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: 20),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10),
              ),
            ),
            onPressed: () async {
              _imagenPaquete = await pickImageFromGallery();
              procesarImagen();
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

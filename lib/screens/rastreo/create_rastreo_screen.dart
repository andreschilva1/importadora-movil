import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/helpers.dart';
import 'package:projectsw2_movil/services/traking_service.dart';
import 'package:projectsw2_movil/widgets/card_container.dart';
import 'package:provider/provider.dart';

class CreateRastreoScreen extends StatefulWidget {
  const CreateRastreoScreen({Key? key}) : super(key: key);

  @override
  State<CreateRastreoScreen> createState() => _CreateRastreoScreenState();
}

class _CreateRastreoScreenState extends State<CreateRastreoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codigoRastreoController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late TrakingService _trakingService;

  @override
  void initState() {
    super.initState();
    _trakingService = Provider.of<TrakingService>(context, listen: false);
  }

  Future<void> registrarPaquete() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      try {
        bool isRegistradoCorrectamente =
            await _trakingService.registrarNumeroTraking(
          _codigoRastreoController.text.trim(),
        );
        if (isRegistradoCorrectamente) {
          isRegistradoCorrectamente = await _trakingService.registrarRastreo(
            codigoRastreo: _codigoRastreoController.text.trim(),
            name: _nameController.text.trim(),
          );
          if (isRegistradoCorrectamente) {
            //navega hacia la ruta anterior
            if (context.mounted) {
            Navigator.pop(context);
          }
          } else {
            displayDialog(
              context,
              'Error al crear el Rastreo',
              'El rastreo no se ha creado correctamente',
              Icons.error,
              Colors.red,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          displayDialog(
            context,
            'Error al crear el Rastreo',
            e.toString(),
            Icons.error,
            Colors.red,
          );
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
        title: const Text('Registrar Rastreo'),
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
                _buildCodigoRastreoTextField(),
                const SizedBox(height: 30),
                _buildNameTextField(),
                const SizedBox(height: 30),
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
        labelText: 'Codigo de rastreo',
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

  Widget _buildNameTextField() {
    return TextFormField(
      autocorrect: false,
      keyboardType: TextInputType.text,
      decoration: InputDecorations.authInputDecoration(
        hintText: 'Nombre',
        labelText: 'Nombre del rastreo',
        prefixIcon: Icons.border_all,
      ),
      controller: _nameController,
      onChanged: (value) => value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese nombre del rastreo';
        }
        return null;
      },
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
        onPressed: _trakingService.isLoading
            ? null
            : () {
                registrarPaquete();
              },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
          child: _trakingService.isLoading
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

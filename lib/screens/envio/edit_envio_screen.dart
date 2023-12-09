// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/helpers.dart';
import 'package:projectsw2_movil/models/estado_envio.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/card_container.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditEnvioScreen extends StatefulWidget {
  final int envio;
  final String? codigo;
  int metodo;
  EditEnvioScreen(
      {Key? key, required this.envio, this.codigo, required this.metodo})
      : super(key: key);

  @override
  State<EditEnvioScreen> createState() => _EditEnvioScreenState();
}

class _EditEnvioScreenState extends State<EditEnvioScreen> {
  TextEditingController codigo = TextEditingController();
  final formKey = GlobalKey<FormState>();
  

  List<DropdownMenuItem<int>> _menuItems = [];

  List<EstadoEnvio> _metodo = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final metodo = Provider.of<EstadoEnvioService>(context);

    if (_metodo.isEmpty) {
      metodo.fetchEstadoEnvios();

      setState(() {
        _metodo = metodo.estadoEnvio!;

        _menuItems = List.generate(
          _metodo.length,
          (i) => DropdownMenuItem(
            value: _metodo[i].id,
            child: Text(_metodo[i].name),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.codigo != null) {
      codigo.text = widget.codigo!;
    }
  }

  @override
  Widget build(BuildContext context) {
    TrakingService seguimientoEnvioService = Provider.of<TrakingService>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 1,
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
        title: const Text('Editando Envio'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Código',
                      labelText: 'Código del envío',
                      prefixIcon: Icons.send,
                    ),
                    onChanged: (value) => value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese el codigo';
                      }
                      return null;
                    },
                    controller: codigo,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Estado del envío',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<int>(
                    isExpanded: true,
                    items: _menuItems,
                    value: widget.metodo,
                    onChanged: (value) => setState(() {
                      widget.metodo = value!;
                    }),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        elevation: 0,
                        color: Colors.black,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 15),
                            child: const Text('Actualizar',
                                style: TextStyle(color: Colors.white))),
                        onPressed: () async{
                          if (formKey.currentState!.validate()) {
                            final isRegistered = await seguimientoEnvioService.registrarNumeroTraking(codigo.text.trim());
                            if (isRegistered) {
                              FocusScope.of(context).unfocus();
                              Provider.of<EnvioService>(context, listen: false)
                                  .updateEnvio(widget.envio, codigo.text.trim(),
                                      widget.metodo, context);
                              Navigator.pop(context);
                                                          
                            }else{
                              showBottomAlert(context: context,
                              message: 'El numero de rastreo no existe',
                              );
                            }

                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          // const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // const SizedBox(height: 50),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/input_decoration.dart';
import 'package:projectsw2_movil/widgets/card_container.dart';

class EditMetodoEnvioScreen extends StatelessWidget {
  final TextEditingController transportista;
  final TextEditingController metodo;
  final TextEditingController costoKg;
  const EditMetodoEnvioScreen({super.key, required this.transportista, required this.metodo, required this.costoKg});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        title: const Text('Editando Método de Envío'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Nombre',
                      labelText: 'Nombre del almacén',
                      prefixIcon: Icons.text_fields,
                    ),
                    onChanged: (value) => value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese el nombre';
                      }
                      return null;
                    },
                    controller: transportista,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Dirección',
                      labelText: 'Dirección del almacén',
                      prefixIcon: Icons.directions,
                    ),
                    onChanged: (value) => value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese la dirección';
                      }
                      return null;
                    },
                    controller: metodo,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Teléfono',
                      labelText: 'Teléfono del almacén',
                      prefixIcon: Icons.phone,
                    ),
                    controller: costoKg,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese el teléfono';
                      }
                      return null;
                    },
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
                            child: const Text('Crear',
                                style: TextStyle(color: Colors.white))),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            // Provider.of<WarehouseProvider>(context,
                            //         listen: false)
                            //     .crearAlmacen(name.text, direccion.text,
                            //         telefono.text, pais.text, context);
                          }
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

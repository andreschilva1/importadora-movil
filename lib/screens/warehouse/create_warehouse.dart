import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/input_decoration.dart';
import 'package:projectsw2_movil/providers/warehouse_provider.dart';
import 'package:projectsw2_movil/widgets/card_container.dart';
import 'package:provider/provider.dart';

class CreateWarehouseScreen extends StatelessWidget {
  const CreateWarehouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController name = TextEditingController();
    TextEditingController direccion = TextEditingController();
    TextEditingController telefono = TextEditingController();
    TextEditingController pais = TextEditingController();

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
        title: const Text('Creando Almacén'),
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
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Nombre',
                        labelText: 'Nombre del almacén',
                        prefixIcon: Icons.text_fields,
                      ),
                      controller: name,
                      onChanged: (value) => value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el nombre';
                        }
                        return null;
                      },
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
                      controller: direccion,
                      onChanged: (value) => value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese la dirección';
                        }
                        return null;
                      },
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
                      controller: telefono,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el teléfono';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'País',
                        labelText: 'País del almacén',
                        prefixIcon: Icons.flag,
                      ),
                      controller: pais,
                      onChanged: (value) => value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese el país';
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
                              Provider.of<WarehouseProvider>(context, listen: false)
                                .crearAlmacen(name.text.trim(), direccion.text.trim(),
                                    telefono.text.trim(), pais.text.trim(), context);
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

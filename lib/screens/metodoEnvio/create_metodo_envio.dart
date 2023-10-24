import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/input_decoration.dart';
import 'package:projectsw2_movil/providers/metodo_envio_provider.dart';
import 'package:projectsw2_movil/widgets/card_container.dart';
import 'package:provider/provider.dart';

class CreateMetodoEnvioScreen extends StatelessWidget {
  const CreateMetodoEnvioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController transportista = TextEditingController();
    TextEditingController metodo = TextEditingController();
    TextEditingController costoKg = TextEditingController();

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
        title: const Text('Creando Método de Envío'),
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
                        hintText: 'Transportista',
                        labelText: 'Transpostista del método de envío',
                        prefixIcon: Icons.business_outlined,
                      ),
                      controller: transportista,
                      onChanged: (value) => value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el transportista del método';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Método',
                        labelText: 'Método del envío',
                        prefixIcon: Icons.airplane_ticket_outlined,
                      ),
                      controller: metodo,
                      onChanged: (value) => value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el método';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Costo por Kg',
                        labelText: 'Costo por Kg del método de envío',
                        prefixIcon: Icons.money_outlined,
                      ),
                      controller: costoKg,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el costo por Kg';
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
                              Provider.of<MetodoEnvioProvider>(context,
                                      listen: false)
                                  .crearMetodoEnvio(
                                      transportista.text.trim(),
                                      metodo.text.trim(),
                                      costoKg.text.trim(),
                                      context);
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

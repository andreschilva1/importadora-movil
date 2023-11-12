import 'package:flutter/material.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
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
                    TextFormCustomer(
                      controller: name, 
                      type: TextInputType.name, 
                      icon: Icons.text_fields, 
                      hintText: 'Nombre', 
                      labelText: 'Nombre del almacén', 
                      aviso: 'Ingrese el nombre',
                    ),
                    const SizedBox(height: 30),
                    TextFormCustomer(
                      controller: direccion, 
                      type: TextInputType.name, 
                      icon: Icons.directions, 
                      hintText: 'Dirección', 
                      labelText: 'Dirección del almacén', 
                      aviso: 'Ingrese la dirección',
                    ),
                    const SizedBox(height: 30),
                    TextFormCustomer(
                      controller: telefono, 
                      type: TextInputType.number, 
                      icon: Icons.phone, 
                      hintText: 'Teléfono', 
                      labelText: 'Teléfono del almacén', 
                      aviso: 'Ingrese el teléfono',
                    ),
                    const SizedBox(height: 30),
                    TextFormCustomer(
                      controller: pais, 
                      type: TextInputType.streetAddress, 
                      icon: Icons.flag, 
                      hintText: 'País', 
                      labelText: 'País del almacén', 
                      aviso: 'Ingrese el país',
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
                              Provider.of<WarehouseService>(context, listen: false).crearAlmacen(
                                name.text.trim(),
                                direccion.text.trim(),
                                telefono.text.trim(),
                                pais.text.trim(),
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

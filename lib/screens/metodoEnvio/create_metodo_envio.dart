import 'package:flutter/material.dart';
import 'package:projectsw2_movil/services/metodo_envio_service.dart';
import 'package:projectsw2_movil/widgets/card_container.dart';
import 'package:projectsw2_movil/widgets/text_form_customer.dart';
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
                    TextFormCustomer(
                      controller: transportista, 
                      type: TextInputType.name, 
                      icon: Icons.business_outlined, 
                      hintText: 'Transpostista', 
                      labelText: 'Transpostista del método de envío', 
                      aviso: 'Ingrese el transportista del método',
                    ),
                    const SizedBox(height: 30),
                    TextFormCustomer(
                      controller: metodo, 
                      type: TextInputType.name, 
                      icon: Icons.airplane_ticket_outlined, 
                      hintText: 'Método', 
                      labelText: 'Método del envío', 
                      aviso: 'Ingrese el método',
                    ),
                    const SizedBox(height: 30),
                    TextFormCustomer(
                      controller: costoKg, 
                      type: TextInputType.number, 
                      icon: Icons.money_outlined, 
                      hintText: 'Costo por Kg', 
                      labelText: 'Costo por Kg del método de envío', 
                      aviso: 'Ingrese el costo por Kg',
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
                              Provider.of<MetodoEnvioService>(context,
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

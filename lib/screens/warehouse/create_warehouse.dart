import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/input_decoration.dart';
import 'package:projectsw2_movil/services/pais_services.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CreateWarehouseScreen extends StatefulWidget {
  const CreateWarehouseScreen({super.key});

  @override
  State<CreateWarehouseScreen> createState() => _CreateWarehouseScreenState();
}

class _CreateWarehouseScreenState extends State<CreateWarehouseScreen> {
  String? paisId;

  @override
  initState() {
    super.initState();
    Provider.of<PaisService>(context, listen: false).fetchPaises();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController name = TextEditingController();
    TextEditingController direccion = TextEditingController();

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
      body: Consumer<PaisService>(
        builder: (context, paisService, child){
          if (paisService.paises!.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
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
                        DropdownButtonFormField<String>(
                          decoration: InputDecorations.authInputDecoration(
                            hintText: 'País',
                            labelText: 'País del almacén',
                            prefixIcon: Icons.flag,
                          ),
                          value: paisId,
                          onChanged: (value) {
                            setState(() {
                              paisId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Debe elegir un país';
                            }
                            return null;
                          },
                          items: paisService.paises!.map((pais) {
                            return DropdownMenuItem<String>(
                              value: pais.id.toString(),
                              child: Text(pais.name),
                            );
                          }).toList()
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
                                  Provider.of<WarehouseService>(context,
                                          listen: false)
                                      .crearAlmacen(name.text.trim(),
                                          direccion.text.trim(), paisId!, context);
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
      ),
    );
  }
}

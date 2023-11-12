import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/input_decoration.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:projectsw2_movil/widgets/card_container.dart';
import 'package:provider/provider.dart';

class CreateEmployeeScreen extends StatefulWidget {
  const CreateEmployeeScreen({super.key});

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  
  String? almacenId; 
    @override
    initState() {
      super.initState();
      Provider.of<WarehouseService>(context, listen: false).fetchWarehouses();
      
    }
  

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController celular = TextEditingController();
    



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
        title: const Text('Creando Empleado'),
      ),
      body: Consumer<WarehouseService>(
        builder: (context, warehouseService, child){
          if (warehouseService.almacenes!.isEmpty) {
            return Center(child: const CircularProgressIndicator());
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
                        TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.name,
                          decoration: InputDecorations.authInputDecoration(
                            hintText: 'Nombre',
                            labelText: 'Nombre del empleado',
                            prefixIcon: Icons.person_4_outlined,
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
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecorations.authInputDecoration(
                            hintText: 'Email',
                            labelText: 'Email del empleado',
                            prefixIcon: Icons.email_outlined,
                          ),
                          controller: email,
                          onChanged: (value) => value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese el email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: InputDecorations.authInputDecoration(
                            hintText: 'Contraseña',
                            labelText: 'Contraseña del empleado',
                            prefixIcon: Icons.lock,
                          ),
                          controller: password,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese la contraseña';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecorations.authInputDecoration(
                            hintText: 'Celular',
                            labelText: 'Celular del empleado',
                            prefixIcon: Icons.phone,
                          ),
                          controller: celular,
                          onChanged: (value) => value,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese el celular';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        DropdownButtonFormField<String>(
                          decoration: InputDecorations.authInputDecoration(
                            hintText: 'almacen',
                            labelText: '',
                            prefixIcon: Icons.store,
                          ),
                          value: almacenId,
                          onChanged: (value) {
                            setState(() {
                              almacenId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Debe elegir un almacen';
                            }
                            return null;
                          },
                          items: warehouseService.almacenes!.map((almacen) {
                                    return DropdownMenuItem<String>(
                                      value: almacen.id.toString(),
                                      child: Text(almacen.name),
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
                                  Provider.of<EmployeeService>(context,
                                          listen: false)
                                      .crearEmpleado(name.text, email.text,
                                          password.text, celular.text,almacenId ?? '' ,context);
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

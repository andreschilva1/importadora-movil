import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:provider/provider.dart';

class ShowCliente extends StatefulWidget {
  final int empleado;
  const ShowCliente({Key? key, required this.empleado}) : super(key: key);

  @override
  State<ShowCliente> createState() => _ShowClienteState();
}

class _ShowClienteState extends State<ShowCliente> {
  Future<User?>? _futureEmpleado;
  @override
  initState() {
    super.initState();
    _futureEmpleado = _loadEmployee();
  }

  Future<User?> _loadEmployee() async {
    return Provider.of<EmployeeService>(context, listen: false).getEmployee(widget.empleado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuario", style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: FutureBuilder<User?>(
        future: _futureEmpleado,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No se encontraron datos'));
          } else {
            User empleado = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width * .8,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("Assets/cliente.jpg", fit: BoxFit.cover),
                        Container(
                          padding: const EdgeInsets.only(top: 100),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage("Assets/user.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      empleado.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              "Email",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            subtitle: Text(
                              empleado.email,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          ListTile(
                            title: const Text(
                              "Teléfono",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            subtitle: Text(
                              empleado.celular!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          const ListTile(
                            title: Text(
                              "Rol",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            subtitle: Text(
                              "Empleado",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          empleado.casillero!.isNotEmpty
                          ? ListTile(
                            title: const Text(
                              "Casillero",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            subtitle: Text(
                              empleado.casillero!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          )
                          : Container(),
                          const Divider(color: Colors.grey),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
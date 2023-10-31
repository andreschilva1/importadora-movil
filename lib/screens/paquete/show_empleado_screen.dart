import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/empleado.dart';
import 'package:projectsw2_movil/services/services.dart';
import 'package:provider/provider.dart';

class ShowEmpleado extends StatefulWidget {
  final int empleado;
  const ShowEmpleado({super.key, required this.empleado});

  @override
  State<ShowEmpleado> createState() => _ShowEmpleadoState();
}

class _ShowEmpleadoState extends State<ShowEmpleado> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuario", style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Empleado?>(
          future: Provider.of<EmployeeService>(context).getEmployee(widget.empleado),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final empleado = snapshot.data;
              return Column(
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
                        Image.asset("Assets/user.jpg", fit: BoxFit.cover),
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
                      empleado!.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: 300,
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
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            subtitle: Text(
                              empleado.email,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          ListTile(
                            title: const Text(
                              "Teléfono",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            subtitle: Text(
                              empleado.celular,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          const ListTile(
                            title: Text(
                              "Rol",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            subtitle: Text(
                              "Empleado",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        ),
      ),
    );
  }
}

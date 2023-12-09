import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/alert.dart';
import 'package:projectsw2_movil/models/empleado.dart';
import 'package:projectsw2_movil/screens/employee/create_employee_screen.dart';
import 'package:projectsw2_movil/services/employee_service.dart';
import 'package:projectsw2_movil/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<EmployeeService>(context, listen: false).fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.playlist_add_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateEmployeeScreen()),
              );
            },
          ),
        ],
        centerTitle: true,
        title: const Text('Empleados'),
      ),
      body: Center(
        child: Consumer<EmployeeService>(
            builder: (context, employeeProvider, child) {
          if (employeeProvider.empleados!.isEmpty) {
            return const CircularProgressIndicator();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height * .9,
            child: ListView.builder(
              itemCount:employeeProvider.empleados!.length,
              itemBuilder: (ctx, index) {
                Empleado empleado = employeeProvider.empleados![index];
                return Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                            Colors.white,
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5)
                          ])),
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                              255, 133, 119, 119)
                                          .withOpacity(0.3),
                                      spreadRadius: 1.2,
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_3_rounded,
                                  color: Color.fromARGB(255, 0, 73, 175),
                                ),
                                // child: Image.network(
                                //   empleado.profilePhotoUrl,
                                //   width: 50,
                                //   height: 50,
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: Text(
                                    empleado.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: Text(
                                    "Email: ${empleado.email}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: Text(
                                    "Teléfono: ${empleado.celular}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  child: Row(
                                    children: <Widget>[
                                      ElevatedButton.icon(
                                          onPressed: () {
                                            showAlertDialog(context, (){
                                              FocusScope.of(context).unfocus();
                                              Provider.of<EmployeeService>(context, listen: false)
                                                  .eliminar(context, empleado.id);
                                            });
                                          },
                                          label: const Text('Eliminar'),
                                          icon: const Icon(Icons.delete),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red[700])),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  child: Row(
                                    children: <Widget>[
                                      ElevatedButton.icon(
                                          onPressed: () {
                                            // showAlertDialog(context, "Empleado", empleado.id);
                                          },
                                          label: const Text('Editar'),
                                          icon: const Icon(Icons.edit),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 0, 76, 255))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projectsw2_movil/helpers/alert.dart';
import 'dart:convert';
import 'package:projectsw2_movil/models/empleado.dart';
import 'package:projectsw2_movil/providers/server_provider.dart';

class EmployeeProvider extends ChangeNotifier {
  List<Empleado>? _empleados = [];

  List<Empleado>? get empleados => _empleados;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> fetchEmployees() async {
    _empleados = await getEmployees();
    notifyListeners();
  }

  Future<List<Empleado>> getEmployees() async {
    final urlPrincipal = ServerProvider().url;
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('$urlPrincipal/api/getEmployees');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      final List<Empleado> empleados =
          empleadoFromJson(jsonEncode(respuesta['data']));
      return empleados;
    } else {
      return List.empty();
    }
  }

  void crearEmpleado(String name, String email, String password, String celular,
      BuildContext context) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ServerProvider().url;

    final response = await http.post(
      Uri.parse('$url/api/createEmployee'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'celular': celular,
      }),
    );

    final respuesta = jsonDecode(response.body);
    if (200 == response.statusCode) {
      fetchEmployees(); // Actualizar el estado después de crear una consulta
      Navigator.pushReplacementNamed(context, 'empleado');
    } else {
      Navigator.pop(context);
      final mensajeErroneo = jsonEncode(respuesta['mensaje']);
      mostrarAlerta(context, 'Error', mensajeErroneo);
    }
  }

  eliminar(BuildContext context, int id) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ServerProvider().url;
    final response = await http.delete(Uri.parse('$url/api/deleteEmployee'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id.toString()}));
    final respuesta = jsonDecode(response.body);
    if (200 == response.statusCode) {
      fetchEmployees();
      Navigator.pushReplacementNamed(context, 'empleado');
    } else {
      Navigator.pop(context);
      final mensajeErroneo = jsonEncode(respuesta['mensaje']);
      mostrarAlerta(context, 'Error', mensajeErroneo);
    }
  }
}

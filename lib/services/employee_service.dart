// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projectsw2_movil/helpers/alert.dart';
import 'dart:convert';
import 'package:projectsw2_movil/models/models.dart';
import 'package:projectsw2_movil/services/api_service.dart';

class EmployeeService extends ChangeNotifier {
  List<Empleado>? _empleados = [];

  List<Empleado>? get empleados => _empleados;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> fetchEmployees() async {
    _empleados = await getEmployees();
    notifyListeners();
  }

  Future<List<Empleado>> getEmployees() async {
    final urlPrincipal = ApiService.baseUrl;
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

  Future<void> crearEmpleado(String name, String email, String password, String celular, String almacenId,

      BuildContext context) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ApiService.baseUrl;

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
        'almacenId':almacenId,
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

  Future<void> eliminar(BuildContext context, int id) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ApiService.baseUrl;
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

  Future<User?> getEmployee(int id) async {
    final urlPrincipal = ApiService.baseUrl;
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('$urlPrincipal/api/editEmployee');
    final response = await http.patch(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
        'id': id,
      }),
    );

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      final User empleado = User.fromJson(jsonEncode(respuesta));
      return empleado;
    } else {
      return null;
    }
  }
}

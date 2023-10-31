import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projectsw2_movil/helpers/alert.dart';
import 'dart:convert';
import 'package:projectsw2_movil/models/almacen.dart';
import 'package:projectsw2_movil/services/server_service.dart';

class WarehouseService extends ChangeNotifier {
  List<Almacen>? _almacenes = [];

  List<Almacen>? get almacenes => _almacenes;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> fetchWarehouses() async {
    _almacenes = await getAlmacenes();
    notifyListeners();
  }

  Future<List<Almacen>> getAlmacenes() async {
    final urlPrincipal = ServerService().url;
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('$urlPrincipal/api/obtenerAlmacenes');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      final List<Almacen> almacenes =
          almacenesFromJson(jsonEncode(respuesta['data']));
      return almacenes;
    } else {
      return List.empty();
    }
  }

  Future<Almacen?> getAlmacen(int id) async {
    final urlPrincipal = ServerService().url;
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('$urlPrincipal/api/editAlmacen');
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
      final Almacen almacen = almacenFromJson(jsonEncode(respuesta['data']));
      return almacen;
    } else {
      return null;
    }
  }

  Future<void> crearAlmacen(String name, String direccion, String telefono, String pais,
      BuildContext context) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ServerService().url;

    final response = await http.post(
      Uri.parse('$url/api/crearAlmacen'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'direccion': direccion,
        'telefono': telefono,
        'pais': pais,
      }),
    );

    final respuesta = jsonDecode(response.body);
    if (200 == response.statusCode) {
      fetchWarehouses(); // Actualizar el estado después de crear una consulta
      Navigator.pushReplacementNamed(context, 'warehouse');
    } else {
      Navigator.pop(context);
      final mensajeErroneo = jsonEncode(respuesta['mensaje']);
      mostrarAlerta(context, 'Error', mensajeErroneo);
    }
  }

  Future<void> eliminar(BuildContext context, int id) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ServerService().url;
    final response = await http.delete(Uri.parse('$url/api/eliminarAlmacen'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id.toString()}));
    final respuesta = jsonDecode(response.body);
    if (200 == response.statusCode) {
      fetchWarehouses();
      Navigator.pushReplacementNamed(context, 'warehouse');
    } else {
      Navigator.pop(context);
      final mensajeErroneo = jsonEncode(respuesta['mensaje']);
      mostrarAlerta(context, 'Error', mensajeErroneo);
    }
  }
}

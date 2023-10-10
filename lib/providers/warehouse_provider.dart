import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projectsw2_movil/helpers/alert.dart';
import 'dart:convert';
import 'package:projectsw2_movil/models/almacen.dart';
import 'package:projectsw2_movil/providers/server_provider.dart';

class WarehouseProvider extends ChangeNotifier {
  List<Almacen>? _almacenes = [];

  List<Almacen>? get almacenes => _almacenes;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> fetchWarehouses() async {
    _almacenes = await getAlmacenes();
    notifyListeners();
  }

  Future<List<Almacen>> getAlmacenes() async {
    final urlPrincipal = ServerProvider().url;
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('$urlPrincipal/api/obtenerAlmacenes');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      final List<Almacen> almacenes =
          almacenFromJson(jsonEncode(respuesta['data']));
      return almacenes;
    } else {
      return List.empty();
    }
  }

  void crearAlmacen(String name, String direccion, String telefono, String pais,
      BuildContext context) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ServerProvider().url;

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

  eliminar(BuildContext context, int id) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ServerProvider().url;
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

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projectsw2_movil/helpers/alert.dart';
import 'dart:convert';
import 'package:projectsw2_movil/models/metodo_envio.dart';
import 'package:projectsw2_movil/services/api_service.dart';

class MetodoEnvioService extends ChangeNotifier {
  List<MetodoEnvio>? _metodoEnvios = [];

  List<MetodoEnvio>? get metodoEnvios => _metodoEnvios;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> fetchMetodoEnvios() async {
    _metodoEnvios = await getMetodoEnvios();
    notifyListeners();
  }

  Future<List<MetodoEnvio>> getMetodoEnvios() async {
    final urlPrincipal = ApiService.baseUrl;
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('$urlPrincipal/api/getMetodoEnvio');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      final List<MetodoEnvio> metodoEnvios =
          metodoEnvioFromJson(jsonEncode(respuesta['data']));
      return metodoEnvios;
    } else {
      return List.empty();
    }
  }

  void crearMetodoEnvio(String transportista, String metodo, String costo_kg, BuildContext context) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ApiService.baseUrl;

    final response = await http.post(
      Uri.parse('$url/api/createMetodoEnvio'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'transportista': transportista,
        'metodo': metodo,
        'costo_kg': costo_kg,
      }),
    );

    final respuesta = jsonDecode(response.body);
    if (200 == response.statusCode) {
      fetchMetodoEnvios(); // Actualizar el estado después de crear una consulta
      Navigator.pushReplacementNamed(context, 'metodoEnvio');
    } else {
      Navigator.pop(context);
      final mensajeErroneo = jsonEncode(respuesta['mensaje']);
      mostrarAlerta(context, 'Error', mensajeErroneo);
    }
  }

  eliminar(BuildContext context, int id) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ApiService.baseUrl;
    final response = await http.delete(Uri.parse('$url/api/deleteMetodoEnvio'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id.toString()}));
    final respuesta = jsonDecode(response.body);
    if (200 == response.statusCode) {
      fetchMetodoEnvios(); 
      Navigator.pushReplacementNamed(context, 'metodoEnvio');
    } else {
      Navigator.pop(context);
      final mensajeErroneo = jsonEncode(respuesta['mensaje']);
      mostrarAlerta(context, 'Error', mensajeErroneo);
    }
  }
}

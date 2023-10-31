import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projectsw2_movil/helpers/alert.dart';
import 'dart:convert';
import 'package:projectsw2_movil/models/envio.dart';
import 'package:projectsw2_movil/services/server_service.dart';

class EnvioService extends ChangeNotifier {
  Envio? _envio;

  Envio? get envio => _envio;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Envio?> getEnvio(int id) async {
    final urlPrincipal = ServerService().url;
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('$urlPrincipal/api/getEnvio');
    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
      }),
    );

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      
      if (respuesta['data'] != null) {
        final Envio envio = envioFromJson(jsonEncode(respuesta['data']));
        return envio;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> createEnvio(int id, int metodo, BuildContext context) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ServerService().url;

    final response = await http.post(
      Uri.parse('$url/api/createEnvio'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'paquete_id': id,
        'metodo_envio_id': metodo,
      }),
    );

    final respuesta = jsonDecode(response.body);
    if (200 == response.statusCode) {
      notifyListeners();
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      final mensajeErroneo = jsonEncode(respuesta['mensaje']);
      mostrarAlerta(context, 'Error', mensajeErroneo);
    }
  }

  Future<void> updateEnvio(int id, String codigo, int estado, BuildContext context) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ServerService().url;

    final response = await http.post(
      Uri.parse('$url/api/storeEnvio'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
        'codigo_rastreo': codigo,
        'envio_estado_id': 2,
      }),
    );

    final respuesta = jsonDecode(response.body);
    if (200 == response.statusCode) {
      notifyListeners();
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      final mensajeErroneo = jsonEncode(respuesta['mensaje']);
      mostrarAlerta(context, 'Error', mensajeErroneo);
    }
  }
}

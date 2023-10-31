import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projectsw2_movil/models/estado_envio.dart';
import 'dart:convert';
import 'package:projectsw2_movil/services/server_service.dart';

class EstadoEnvioService extends ChangeNotifier {
  List<EstadoEnvio>? _estadoEnvio = [];

  List<EstadoEnvio>? get estadoEnvio => _estadoEnvio;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> fetchEstadoEnvios() async {
    _estadoEnvio = await getEstadoEnvio();
    notifyListeners();
  }

  Future<List<EstadoEnvio>> getEstadoEnvio() async {
    final urlPrincipal = ServerService().url;
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('$urlPrincipal/api/getEstadoEnvio');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      final List<EstadoEnvio> estadoEnvios =
          estadoEnvioFromJson(jsonEncode(respuesta['data']));
      return estadoEnvios;
    } else {
      return List.empty();
    }
  }
}

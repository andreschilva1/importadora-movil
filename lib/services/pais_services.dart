import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projectsw2_movil/models/pais.dart';
import 'package:projectsw2_movil/services/api_service.dart';

class PaisService extends ChangeNotifier {
  List<Pais>? _paises = [];

  List<Pais>? get paises => _paises;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> fetchPaises() async {
    _paises = await getPaises();
    notifyListeners();
  }

  Future<List<Pais>> getPaises() async {
    final urlPrincipal = ApiService.baseUrl;
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('$urlPrincipal/api/getPaises');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      final List<Pais> paises = paisesFromJson(jsonEncode(respuesta['data']));
      return paises;
    } else {
      return List.empty();
    }
  }
}

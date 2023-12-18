// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projectsw2_movil/helpers/alert.dart';
import 'package:projectsw2_movil/models/paquete.dart';
import 'package:projectsw2_movil/services/api_service.dart';

class PaqueteService extends ChangeNotifier {
  List<Paquete>? _paquetesSinEnviar = [];
  List<Paquete>? _paquetesConsolidados = [];
  List<Paquete>? _paquetesEnviados = [];

  List<Paquete>? get paquetesSinEnviar => _paquetesSinEnviar;
  List<Paquete>? get paquetesConsolidados => _paquetesConsolidados;
  List<Paquete>? get paquetesEnviados => _paquetesEnviados;

  ApiService apiService = ApiService();
  static final String _baseUrl = ApiService.baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  bool isLoading = false;

  Future<void> fetchPaquetes() async {
    final rol = await _storage.read(key: 'rol');

    _paquetesSinEnviar = await getPaquetesSinEnviar();
    
    if (rol != 'Encargado de Envio') {
      _paquetesConsolidados = await getPaquetesConsolidados(); 
    }
    
    if (rol != 'Encargado de Almacen') {
      _paquetesEnviados = await getPaquetesEnviados();
    }
    notifyListeners();
  }

  Future<List<Paquete>> getPaquetesSinEnviar() async {
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('$_baseUrl/api/obtenerPaquetes');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(response.body);
      final List<Paquete> paquetes =
          paqueteFromJson(jsonEncode(respuesta['data']));
      // debugPrint(paquetes);
      return paquetes;
    } else {
      return List.empty();
    }
  }

  Future<List<Paquete>> getPaquetesAlmacen(int almacenId) async {
    final token = await _storage.read(key: 'token');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final request =
        http.Request('GET', Uri.parse('$_baseUrl/api/obtenerPaquetesAlmacen'));
    request.body = json.encode({"almacenId": almacenId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final body = await response.stream.bytesToString();

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(body);
      final List<Paquete> paquetes =
          paqueteFromJson(jsonEncode(respuesta['data']));
      return paquetes;
    } else {
      return List.empty();
    }
  }

  Future<List<Paquete>> getPaquetesConsolidacion(int paqueteId) async {
    final token = await _storage.read(key: 'token');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final request = http.Request(
        'GET', Uri.parse('$_baseUrl/api/obtenerPaquetesConsolidacion'));
    request.body = json.encode({"paqueteId": paqueteId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final body = await response.stream.bytesToString();

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(body);
      final List<Paquete> paquetes =
          paqueteFromJson(jsonEncode(respuesta['data']));
      return paquetes;
    } else {
      return List.empty();
    }
  }

  Future<List<Paquete>> getPaquetesConsolidados() async {
    final response = await apiService.get('api/obtenerPaquetesConsolidados');
    if (200 == response.statusCode) {
      final body = jsonDecode(response.body);
      final List<Paquete> paquetes =paqueteFromJson(jsonEncode(body['data']));
      return paquetes;
    } else {
      return List.empty();
    }
  }

  Future<List<Paquete>> getPaquetesEnviados() async {
    final response = await apiService.get('api/obtenerPaquetesEnviados');
    if (200 == response.statusCode) {
      final body = jsonDecode(response.body);
      final List<Paquete> paquetes =paqueteFromJson(jsonEncode(body['data']));
      return paquetes;
    } else {
      return List.empty();
    }
  }

  Future subirImagen(
      {required File imageFile, required BuildContext context}) async {
    mostrarLoading(context, mensaje: 'Subiendo Imagen...');

    String? token = await _storage.read(key: 'token');
    if (token == null) {
      debugPrint('No hay token');
      return;
    }

    var headers = {
      'Content-Type': 'aplication/json',
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/api/guardarimagenPaquete'), // Cambia a tu URL
    );

    request.headers.addAll(headers);
    request.files
        .add(await http.MultipartFile.fromPath('imagen', imageFile.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = await response.stream.bytesToString();
        var imagenUrl = json.decode(jsonResponse);
        debugPrint(imagenUrl);
        return imagenUrl;
      } else {
        debugPrint(
            'error al subir la imagen. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error en la solicitud: $e');
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future obtenerDatosDeImagen(
      {required String imageUrl, required BuildContext context}) async {
    try {
      mostrarLoading(context, mensaje: 'Analizando imagen...');

      final response = await apiService.post('api/reconocerPaquete', {
        'imege_url': imageUrl,
      });

      if (response.statusCode == 200) {
        var codigoYcasillero = json.decode(response.body);
        //debugPrint(codigoYcasillero);
        return codigoYcasillero;
      } else {
        debugPrint(
            'Error en la respuesta en obtenerDatosDeImagen. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error en la solicitud: $e');
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<dynamic> getClienteDelPaquete(String nuemeroCasillero) async {
    try {
      final response = await apiService.post('api/getClienteByCasillero', {
        'numero_casillero': nuemeroCasillero,
      });

      if (response.statusCode == 200) {
        final cliente = jsonDecode(response.body);
        return cliente;
      } else {
        debugPrint(response.body);
        return null;
      }
    } catch (e) {
      debugPrint('Error en la solicitud: $e');
    }
  }

  Future<bool> createPaquete({
    required photoPath,
    required codigoRastreo,
    required peso,
    required clienteId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await apiService.post('api/createPaquete', {
        'photo_path': photoPath,
        'codigo_rastreo': codigoRastreo,
        'peso': peso,
        'cliente_id': clienteId,
      });
      if (response.statusCode == 200) {
        fetchPaquetes();
        debugPrint(response.body);
        return true;
      } else {
        debugPrint('error en la respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error en la solicitud: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registrarConsolidacion({
    required paqueteId,
    required photoPath,
    required codigoRastreo,
    required peso,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await apiService.post('api/registrarConsolidacion', {
        'paqueteId': paqueteId,
        'photo_path': photoPath,
        'codigo_rastreo': codigoRastreo,
        'peso': peso,
      });
      if (response.statusCode == 200) {
        fetchPaquetes();
        debugPrint(response.body);
        return true;
      } else {
        debugPrint('error en la respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error en la solicitud: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> crearConsolidacion(String peso, int almacenId,
      List<int> listaIds, BuildContext context) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ApiService.baseUrl;

    final response = await http.post(
      Uri.parse('$url/api/createConsolidacion'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'peso': peso,
        'almacenId': almacenId,
        'lista_ids_paquetes': listaIds,
      }),
    );

    final respuesta = jsonDecode(response.body);
    if (200 == response.statusCode) {
      fetchPaquetes();
      Navigator.pushReplacementNamed(context, 'paquete');
    } else {
      Navigator.pop(context);
      final mensajeErroneo = jsonEncode(respuesta['mensaje']);
      mostrarAlerta(context, 'Error', mensajeErroneo);
    }
  }

  Future<List<Paquete>> getPaquetesEditar(int almacenId,paqueteId) async {
    final token = await _storage.read(key: 'token');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final request = http.Request(
        'GET', Uri.parse('$_baseUrl/api/obtenerPaquetesAlmacenEditar'));
    request.body = json.encode({"almacenId": almacenId,"paqueteId":paqueteId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final body = await response.stream.bytesToString();

    if (200 == response.statusCode) {
      final respuesta = jsonDecode(body);
      final List<Paquete> paquetes =
          paqueteFromJson(jsonEncode(respuesta['data']));
      return paquetes;
    } else {
      return List.empty();
    }
  }

  Future<void> editConsolidacion(int paqueteId, String peso, List<int> listaIds,
      BuildContext context) async {
    mostrarLoading(context);
    final token = await _storage.read(key: 'token');
    final url = ApiService.baseUrl;

    final response = await http.post(
      Uri.parse('$url/api/editConsolidacion'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "paqueteId": paqueteId,
        'peso': peso,
        'lista_ids_paquetes': listaIds,
      }),
    );

    final respuesta = jsonDecode(response.body);
    if (200 == response.statusCode) {
      fetchPaquetes();
      Navigator.pushReplacementNamed(context, 'paquete');
    } else {
      Navigator.pop(context);
      final mensajeErroneo = jsonEncode(respuesta['mensaje']);
      mostrarAlerta(context, 'Error', mensajeErroneo);
    }
  }
}

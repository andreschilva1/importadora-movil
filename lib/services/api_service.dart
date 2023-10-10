import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.0.6:8000';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

 
  Future<http.Response> get(String path) async {
    final token = await _storage.read(key: 'token');
    final url = '$_baseUrl/$path';
    final response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
    return response;
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final token = await _storage.read(key: 'token');
    final url = '$_baseUrl/$path';
    final response = await http.post(Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'}, body: json.encode(body));
    return response;
  }

  Future<http.Response> put(String path, Map<String, dynamic> body) async {
    final token = await _storage.read(key: 'token');
    final url = '$_baseUrl/$path';
    final response = await http.put(Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'}, body: json.encode(body));
    return response;
  }

  Future<http.Response> delete(String path) async {
    final token = await _storage.read(key: 'token');
    final url = '$_baseUrl/$path';
    final response = await http
        .delete(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
    return response;
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projectsw2_movil/services/api_service.dart';

class AuthService extends ChangeNotifier {
  static final String _baseUrl = ApiService.baseUrl;
  static User? user;
  bool isLoading = false;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    logout();
    isLoading = true;
    notifyListeners();


    String url = '$_baseUrl/api/login';

    final response = await http.post(Uri.parse(url), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];
      user = User.fromJson(response.body);

      await _storage.write(key: 'token', value: token);

      print(token);
      await storageWrite(token, user?.id, user!.email, user!.name, user!.rol,
          user?.celular, user?.foto);
     
     
      print('success login');
     
      isLoading = false;
      notifyListeners();
      return true;
    
    } else {
      print('Failed to login');
      return false;
      //throw Exception('Failed to login');
    }
    
  }

  void register(String name, String email, String password, String celular) async {

    String url = '$_baseUrl/api/createClient';

    final response = await http.post(Uri.parse(url), body: {
      'name': name,
      'email': email,
      'password': password,
      'celular': celular
    });

    if (200 == response.statusCode) {
      print('success register');
    } else {
      print('Failed to register');
    }
    
  }

  Future<bool> checkAuth() async {
    final token = await _storage.read(key: 'token');
    if (token == null) {
      return false;
    }
    String  url = '$_baseUrl/api/user';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      await _storage.delete(key: 'token');
      return false;
    }
  }

  Future<void> logout() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      String  url = '$_baseUrl/api/logout';
      final response = await http.get(Uri.parse(url),headers: {
        'Authorization': 'Bearer $token',
      });

    }

    await _storage.deleteAll();
  }

  Future storageWrite(String idToken , int? id , String email, String name,
      String rol, String? celular, String? foto) async {
    await _storage.write(key: 'token', value: idToken);
    await _storage.write(key: 'id', value: id.toString() );
    await _storage.write(key: 'name', value: name);
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'rol', value: rol);
    await _storage.write(key: 'celular', value: celular);
    await _storage.write(key: 'foto', value: foto);
  }

  Future<User> readUser() async {
    final id = await _storage.read(key: 'id');
    final name = await _storage.read(key: 'name');
    final email = await _storage.read(key: 'email');
    final rol = await _storage.read(key: 'rol');
    final celular = await _storage.read(key: 'celular');
    final foto = await _storage.read(key: 'foto');

    return User(
      id: int.tryParse(id ?? ''),
      name: name ?? '',
      email: email ?? '',
      rol: rol ?? '',
      celular: celular ?? '',
      foto: foto ?? '',
    );
  }
}

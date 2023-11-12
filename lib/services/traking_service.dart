import 'package:flutter/material.dart';
import 'package:projectsw2_movil/helpers/alert.dart';
import 'package:projectsw2_movil/models/models.dart';
import 'dart:convert';
import 'package:projectsw2_movil/services/services.dart';

class TrakingService extends ChangeNotifier {
  ApiService apiService = ApiService();
  bool _isLoading = false;
  Seguimiento? _seguimiento;
  
  bool get isLoading => _isLoading;
  Seguimiento? get seguimiento => _seguimiento;
  
  Future<void> fetchSeguimientos(String numeroRastreo, BuildContext context) async {
    _seguimiento = await getTrackInfo(numeroRastreo, context);
    notifyListeners();
  }
  

  Future<dynamic> getTrackInfo(
      String numeroRastreo, BuildContext context) async {
    try {

      final response = await apiService.post('api/getTrackInfo', {
        'numeroRastreo': numeroRastreo,
      });
      print('ejecutandose el metodo getTrackInfo');
      if (response.statusCode == 200) {
        Seguimiento seguimiento =
            Seguimiento.fromJson(jsonDecode(response.body));
        return seguimiento;
      } else {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      if (context.mounted) {
        displayDialog(context, 'Error',
            'Numero de Rastreo no Encontrado', Icons.error, Colors.red);
      }
    }
  }

  Future<dynamic> registrarNumeroTraking(String numeroRastreo) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.post('api/registrarNumeroTraking', {
        'numeroRastreo': numeroRastreo,
      });

      if (response.statusCode == 200) {
        print('registrado correctamente');
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> registrarRastreo({
    String? name = '',
    required String codigoRastreo,
  }) async {
    try {
      _isLoading = true;
      final response = await apiService.post('api/resgistrarRastreo', {
        'name': name,
        'codigoRastreo': codigoRastreo,
      });

      if (response.statusCode == 200) {
        print('registrado correctamente');
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> obtenerRastreos() async {
    try {
      final response = await apiService.get('api/getRastreos');
      List<Rastreo> rastreos = [];
      if (response.statusCode == 200) {
        List<Rastreo> rastreos = rastreoFromJson(response.body);
        return rastreos;
      } else {
        return rastreos;
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }

  Future<dynamic> getCarriers(BuildContext context) async {
    try {
      mostrarLoading(context, mensaje: 'cargando transportistas');
      final response = await apiService.get('api/getCarriers');
      List<Carrier> carriers = [];
      if (response.statusCode == 200) {
        carriers = carrierFromJson(response.body);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        return carriers;
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      print('Error en la solicitud: $e');

      if (context.mounted) {
        Navigator.of(context).pop();
        displayDialog(
            context,
            'Error',
            'No se puedieron cargar los transportistas',
            Icons.error,
            Colors.red);
      }
    }
  }

  Future<dynamic> changeCarrier(BuildContext context,
      {required String numeroRastreo,
      required int carrierOld,
      required int carrierNew}) async {
        mostrarLoading(context, mensaje: 'cambiando transportista');
    try {
      final response = await apiService.post('api/changeCarrier', {
        'numeroRastreo': numeroRastreo,
        'carrierOld': carrierOld,
        'carrierNew': carrierNew
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      if (context.mounted) {
        displayDialog(context, 'Error',
            'error al cambiar de transportista', Icons.error, Colors.red);
      }
    }finally{
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

// To parse this JSON data, do
//
//     final metodoEnvio = metodoEnvioFromJson(jsonString);

import 'dart:convert';

import 'package:projectsw2_movil/models/pais.dart';

List<MetodoEnvio> metodoEnvioFromJson(String str) => List<MetodoEnvio>.from(json.decode(str).map((x) => MetodoEnvio.fromJson(x)));

String metodoEnvioToJson(List<MetodoEnvio> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MetodoEnvio {
    int id;
    String transportista;
    String metodo;
    String costoKg;
    int pais_id;
    String? createdAt;
    String? updatedAt;
    Pais pais;

    MetodoEnvio({
        required this.id,
        required this.transportista,
        required this.metodo,
        required this.costoKg,
        required this.pais_id,
        this.createdAt,
        this.updatedAt,
        required this.pais,
    });

    factory MetodoEnvio.fromJson(Map<String, dynamic> json) => MetodoEnvio(
        id: json["id"],
        transportista: json["transportista"],
        metodo: json["metodo"],
        costoKg: json["costo_kg"],
        pais_id: json["pais_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        pais: Pais.fromJson(json["pais"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "transportista": transportista,
        "metodo": metodo,
        "costo_kg": costoKg,
        "pais_id": pais_id,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "pais": pais.toJson(),
    };

    @override
    String toString() {
      return 'trasportista: $transportista - metodo: $metodo - costo por kg: $costoKg';
    }
}

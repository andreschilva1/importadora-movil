// To parse this JSON data, do
//
//     final metodoEnvio = metodoEnvioFromJson(jsonString);

import 'dart:convert';

List<MetodoEnvio> metodoEnvioFromJson(String str) => List<MetodoEnvio>.from(json.decode(str).map((x) => MetodoEnvio.fromJson(x)));

String metodoEnvioToJson(List<MetodoEnvio> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MetodoEnvio {
    int id;
    String transportista;
    String metodo;
    String costoKg;
    String? createdAt;
    String? updatedAt;

    MetodoEnvio({
        required this.id,
        required this.transportista,
        required this.metodo,
        required this.costoKg,
        this.createdAt,
        this.updatedAt,
    });

    factory MetodoEnvio.fromJson(Map<String, dynamic> json) => MetodoEnvio(
        id: json["id"],
        transportista: json["transportista"],
        metodo: json["metodo"],
        costoKg: json["costo_kg"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "transportista": transportista,
        "metodo": metodo,
        "costo_kg": costoKg,
        "created_at": createdAt,
        "updated_at": updatedAt
    };

    @override
    String toString() {
      return 'trasportista: $transportista - metodo: $metodo - costo por kg: $costoKg';
    }
}

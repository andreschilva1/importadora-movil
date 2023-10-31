// To parse this JSON data, do
//
//     final estadoEnvio = estadoEnvioFromJson(jsonString);

import 'dart:convert';

List<EstadoEnvio> estadoEnvioFromJson(String str) => List<EstadoEnvio>.from(json.decode(str).map((x) => EstadoEnvio.fromJson(x)));

String estadoEnvioToJson(List<EstadoEnvio> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EstadoEnvio {
    int id;
    String name;
    String? createdAt;
    String? updatedAt;

    EstadoEnvio({
        required this.id,
        required this.name,
        this.createdAt,
        this.updatedAt,
    });

    factory EstadoEnvio.fromJson(Map<String, dynamic> json) => EstadoEnvio(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

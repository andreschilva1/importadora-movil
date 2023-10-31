// To parse this JSON data, do
//
//     final almacen = almacenFromJson(jsonString);

import 'dart:convert';

List<Almacen> almacenesFromJson(String str) => List<Almacen>.from(json.decode(str).map((x) => Almacen.fromJson(x)));

String almacenToJson(List<Almacen> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Almacen almacenFromJson(String str) => Almacen.fromJson(json.decode(str));

class Almacen {
    int id;
    String name;
    String direccion;
    String telefono;
    String pais;
    String? createdAt;
    String? updatedAt;

    Almacen({
        required this.id,
        required this.name,
        required this.direccion,
        required this.telefono,
        required this.pais,
        this.createdAt,
        this.updatedAt,
    });

    factory Almacen.fromJson(Map<String, dynamic> json) => Almacen(
        id: json["id"],
        name: json["name"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        pais: json["pais"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "direccion": direccion,
        "telefono": telefono,
        "pais": pais,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

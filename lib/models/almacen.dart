// To parse this JSON data, do
//
//     final almacen = almacenFromJson(jsonString);

import 'dart:convert';

import 'package:projectsw2_movil/models/pais.dart';

List<Almacen> almacenesFromJson(String str) => List<Almacen>.from(json.decode(str).map((x) => Almacen.fromJson(x)));

String almacenToJson(List<Almacen> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Almacen almacenFromJson(String str) => Almacen.fromJson(json.decode(str));

class Almacen {
    int id;
    String name;
    String direccion;
    int pais_id;
    String? createdAt;
    String? updatedAt;
    Pais pais;

    Almacen({
        required this.id,
        required this.name,
        required this.direccion,
        required this.pais_id,
        this.createdAt,
        this.updatedAt,
        required this.pais,
    });

    factory Almacen.fromJson(Map<String, dynamic> json) => Almacen(
        id: json["id"],
        name: json["name"],
        pais_id: json["pais_id"],
        direccion: json["direccion"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        pais: Pais.fromJson(json["pais"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "pais_id": pais_id,
        "direccion": direccion,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "pais": pais.toJson(),
    };
}

// To parse this JSON data, do
//
//     final pais = paisFromJson(jsonString);

import 'dart:convert';

List<Pais> paisesFromJson(String str) => List<Pais>.from(json.decode(str).map((x) => Pais.fromJson(x)));

String paisToJson(List<Pais> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Pais paisFromJson(String str) => Pais.fromJson(json.decode(str));


class Pais {
    int id;
    String name;
    String? createdAt;
    String? updatedAt;

    Pais({
        required this.id,
        required this.name,
        this.createdAt,
        this.updatedAt,
    });

    factory Pais.fromJson(Map<String, dynamic> json) => Pais(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt
    };
}

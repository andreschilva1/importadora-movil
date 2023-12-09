import 'dart:convert';

List<Rastreo> rastreoFromJson(String str) => List<Rastreo>.from(json.decode(str).map((x) => Rastreo.fromJson(x)));

String rastreoToJson(List<Rastreo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rastreo {
    int id;
    String name;
    String codigoRastreo;
    int usuarioId;
    DateTime createdAt;
    DateTime updatedAt;

    Rastreo({
        required this.id,
        required this.name,
        required this.codigoRastreo,
        required this.usuarioId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Rastreo.fromJson(Map<String, dynamic> json) => Rastreo(
        id: json["id"],
        name: json["name"],
        codigoRastreo: json["codigo_rastreo"],
        usuarioId: json["usuario_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "codigo_rastreo": codigoRastreo,
        "usuario_id": usuarioId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

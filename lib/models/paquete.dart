import 'dart:convert';

List<Paquete> almacenFromJson(String str) => List<Paquete>.from(json.decode(str).map((x) => Paquete.fromJson(x)));

String almacenToJson(List<Paquete> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Paquete {
    int id;
    String photoPath;
    String codigoRastreo;
    String peso;
    String? createdAt;
    String? updatedAt;

    Paquete({
        required this.id,
        required this.photoPath,
        required this.codigoRastreo,
        required this.peso,
        this.createdAt,
        this.updatedAt,
    });

    factory Paquete.fromJson(Map<String, dynamic> json) => Paquete(
        id: json["id"],
        photoPath: json["photoPath"],
        codigoRastreo: json["codigoRastreo"],
        peso: json["peso"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "photoPath": photoPath,
        "codigoRastreo": codigoRastreo,
        "peso": peso,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

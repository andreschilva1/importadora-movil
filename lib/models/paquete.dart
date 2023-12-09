import 'dart:convert';

List<Paquete> paqueteFromJson(String str) => List<Paquete>.from(json.decode(str).map((x) => Paquete.fromJson(x)));

String paqueteToJson(List<Paquete> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Paquete {
    int id;
    String? photoPath;
    String? codigo_rastreo;
    String peso;
    int cliente_id;
    int? empleado_id;
    int almacen_id;
    int consolidacion_estado_id;
    int? consolidado_id;
    String? createdAt;
    String? updatedAt;

    Paquete({
        required this.id,
        this.photoPath,
        this.codigo_rastreo,
        required this.peso,
        required this.cliente_id,
        this.empleado_id,
        required this.almacen_id,
        required this.consolidacion_estado_id,
        this.consolidado_id,
        this.createdAt,
        this.updatedAt,
    });

    factory Paquete.fromJson(Map<String, dynamic> json) => Paquete(
        id: json["id"],
        photoPath: json["photo_path"],
        codigo_rastreo: json["codigo_rastreo"],
        peso: json["peso"],
        cliente_id: json["cliente_id"],
        empleado_id: json["empleado_id"],
        almacen_id: json["almacen_id"],
        consolidacion_estado_id: json["consolidacion_estado_id"],
        consolidado_id: json["consolidado_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"], 
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "photoPath": photoPath,
        "codigo_rastreo": codigo_rastreo,
        "peso": peso,
        "cliente_id": cliente_id,
        "empleado_id": empleado_id,
        "almacen_id": almacen_id,
        "consolidacion_estado_id": consolidacion_estado_id,
        "consolidado_id": consolidado_id,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };

    @override
    String toString() {
      return 'Paquete{id: $id, photoPath: $photoPath, codigoRastreo: $codigo_rastreo, peso: $peso}';
    }
}

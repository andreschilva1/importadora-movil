// To parse this JSON data, do
//
//     final envio = envioFromJson(jsonString);

import 'dart:convert';

Envio envioFromJson(String str) => Envio.fromJson(json.decode(str));

String envioToJson(Envio data) => json.encode(data.toJson());

class Envio {
    int id;
    String? codigoRastreo;
    String costo;
    int paqueteId;
    int metodoEnvioId;
    String transportista;
    String metodo;
    String costoKg;
    int envioEstadoId;
    String name;

    Envio({
        required this.id,
        this.codigoRastreo,
        required this.costo,
        required this.paqueteId,
        required this.metodoEnvioId,
        required this.transportista,
        required this.metodo,
        required this.costoKg,
        required this.envioEstadoId,
        required this.name,
    });

    factory Envio.fromJson(Map<String, dynamic> json) => Envio(
        id: json["id"],
        codigoRastreo: json["codigo_rastreo"],
        costo: json["costo"],
        paqueteId: json["paquete_id"],
        metodoEnvioId: json["metodo_envio_id"],
        transportista: json["transportista"],
        metodo: json["metodo"],
        costoKg: json["costo_kg"],
        envioEstadoId: json["envio_estado_id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "codigo_rastreo": codigoRastreo,
        "costo": costo,
        "paquete_id": paqueteId,
        "metodo_envio_id": metodoEnvioId,
        "transportista": transportista,
        "metodo": metodo,
        "costo_kg": costoKg,
        "envio_estado_id": envioEstadoId,
        "name": name,
    };
}

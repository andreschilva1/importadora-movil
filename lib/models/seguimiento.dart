// To parse this JSON data, do
//
//     final seguimiento = seguimientoFromJson(jsonString);

import 'dart:convert';

Seguimiento seguimientoFromJson(String str) => Seguimiento.fromJson(json.decode(str));

String seguimientoToJson(Seguimiento data) => json.encode(data.toJson());

class Seguimiento {
    String? paisOrigen;
    String? paisDestino;
    String? estadoActual;
    int? diasEnTransito;
    int? carrierCode;
    String? carrierName;
    List<Evento> eventos;

    Seguimiento({
        required this.paisOrigen,
        required this.paisDestino,
        required this.estadoActual,
        required this.diasEnTransito,
        required this.carrierCode,
        required this.carrierName,
        required this.eventos,
    });

    factory Seguimiento.fromJson(Map<String, dynamic> json) => Seguimiento(
        paisOrigen: json["paisOrigen"],
        paisDestino: json["paisDestino"],
        estadoActual: json["estadoActual"],
        diasEnTransito: json["diasEnTransito"],
        carrierCode: json["carrierCode"],
        carrierName: json["carrierName"],
        eventos: List<Evento>.from(json["eventos"].map((evento) => Evento.fromJson(evento))),
    );

    Map<String, dynamic> toJson() => {
        "paisOrigen": paisOrigen,
        "paisDestino": paisDestino,
        "estadoActual": estadoActual,
        "diasEnTransito": diasEnTransito,
        "carrierCode": carrierCode,
        "carrierName": carrierName,
        "eventos": List<dynamic>.from(eventos.map((x) => x.toJson())),
    };
}

class Evento {
    String? description;
    String? location;
    DateTime? timeUtc;

    Evento({
        required this.description,
        this.location,
        this.timeUtc,
    });

    factory Evento.fromJson(Map<String, dynamic> json) => Evento(
        description: json["description"] ?? '',
        location: json["location"] ?? '',
        timeUtc: DateTime.parse(json["time_utc"]) ,
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "location": location,
        "time_utc": timeUtc,
    };
}

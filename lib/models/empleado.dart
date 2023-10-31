// To parse this JSON data, do
//
//     final empleado = empleadoFromJson(jsonString);

import 'dart:convert';

List<Empleado> empleadoFromJson(String str) => List<Empleado>.from(json.decode(str).map((x) => Empleado.fromJson(x)));

String empleadoToJson(List<Empleado> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Empleado empleadoFromJson1(String str) => Empleado.fromJson(json.decode(str));

class Empleado {
    int id;
    String name;
    String email;
    String? emailVerifiedAt;
    String? currentTeamId;
    String? profilePhotoPath;
    String celular;
    String? createdAt;
    String? updatedAt;
    String? twoFactorConfirmedAt;
    String profilePhotoUrl;

    Empleado({
        required this.id,
        required this.name,
        required this.email,
        this.emailVerifiedAt,
        this.currentTeamId,
        this.profilePhotoPath,
        required this.celular,
        this.createdAt,
        this.updatedAt,
        this.twoFactorConfirmedAt,
        required this.profilePhotoUrl,
    });

    factory Empleado.fromJson(Map<String, dynamic> json) => Empleado(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        currentTeamId: json["current_team_id"],
        profilePhotoPath: json["profile_photo_path"],
        celular: json["celular"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        twoFactorConfirmedAt: json["two_factor_confirmed_at"],
        profilePhotoUrl: json["profile_photo_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "current_team_id": currentTeamId,
        "profile_photo_path": profilePhotoPath,
        "celular": celular,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "two_factor_confirmed_at": twoFactorConfirmedAt,
        "profile_photo_url": profilePhotoUrl,
    };
}

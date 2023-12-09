import 'dart:convert';

class User {
  User({
    this.id,
    required this.name,
    required this.email,
    required this.rol,
    this.celular,
    this.foto,
    this.casillero,
    this.almacen,
  });

  int? id;
  String name;
  String email;
  String rol;
  String? celular;
  String? foto;
  String? casillero;
  String? almacen;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        rol: json["rol"],
        celular: json["celular"],
        foto: json["photo_path"],
        casillero: json["casillero"],
        almacen: json["almacen"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "rol": rol,
        "celular": celular,
        "foto": foto,
        "casillero": casillero ?? '',
        "almacen": almacen ?? '',
      };

  bool get isEmpty => id == 0 && name.isEmpty && email.isEmpty;

}

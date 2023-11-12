import 'dart:convert';

List<Carrier> carrierFromJson(String str) => List<Carrier>.from(json.decode(str).map((x) => Carrier.fromJson(x)));

String carrierToJson(List<Carrier> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Carrier {
    String? name;
    int? key;
    String? url;

    Carrier({
        required this.name,
        required this.key,
        required this.url,
    });

    factory Carrier.fromJson(Map<String, dynamic> json) => Carrier(
        name: json["name"] ?? '',
        key: json["key"] ?? 0,
        url: json["url"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "key": key,
        "url": url,
    };
}

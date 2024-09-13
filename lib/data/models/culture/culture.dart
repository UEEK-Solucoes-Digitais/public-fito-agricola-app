import 'package:fitoagricola/data/models/pest/pest.dart';

class Culture {
  int? id;
  String? name;
  String? extraColumn;
  int? type;
  List<Pest>? pests;
  dynamic admin;

  Culture({
    this.id,
    this.name,
    this.extraColumn,
    this.type,
    this.pests,
    this.admin,
  });

  factory Culture.fromJson(Map<String, dynamic> json) => Culture(
        id: json["id"],
        name: json["name"],
        extraColumn: json["extra_column"],
        type: json["type"],
        pests: json["pests"] == null ? [] : Pest.fromJsonList(json["pests"]!),
        admin: json["admin"],
      );
}

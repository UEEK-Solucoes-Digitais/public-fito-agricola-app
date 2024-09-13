import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/pest/pest.dart';
import 'package:fitoagricola/data/models/property_crop/property_crop.dart';

class PestReport {
  int id;
  int? propertiesCropsId;
  int? interferenceFactorsItemId;
  int? status;
  int? adminId;
  DateTime? openDate;
  int? risk;
  String? incidency;
  String? quantityPerMeter;
  String? quantityPerSquareMeter;
  PropertyCrop? propertyCrop;
  Pest? pest;
  Admin? admin;

  PestReport({
    required this.id,
    required this.propertiesCropsId,
    required this.interferenceFactorsItemId,
    required this.status,
    required this.adminId,
    required this.openDate,
    required this.risk,
    required this.incidency,
    required this.quantityPerMeter,
    required this.quantityPerSquareMeter,
    required this.propertyCrop,
    required this.pest,
    required this.admin,
  });

  factory PestReport.fromJson(Map<String, dynamic> json) => PestReport(
        id: json["id"],
        propertiesCropsId: json["properties_crops_id"],
        interferenceFactorsItemId: json["interference_factors_item_id"],
        status: json["status"],
        adminId: json["admin_id"],
        openDate: json["open_date"] != null
            ? DateTime.parse(json["open_date"])
            : json["open_date"],
        risk: json["risk"],
        incidency: json["incidency"],
        quantityPerMeter: json["quantity_per_meter"],
        quantityPerSquareMeter: json["quantity_per_square_meter"],
        propertyCrop: json["property_crop"] == null
            ? json["property_crop"]
            : PropertyCrop.fromJson(json["property_crop"]),
        pest: json["pest"] == null ? json["pest"] : Pest.fromJson(json["pest"]),
        admin: json["admin"] == null
            ? json["admin"]
            : Admin.fromJson(json["admin"]),
      );

  static List<PestReport> fromJsonList(List<dynamic> json) {
    List<PestReport> products = [];
    for (var item in json) {
      products.add(PestReport.fromJson(item));
    }
    return products;
  }
}

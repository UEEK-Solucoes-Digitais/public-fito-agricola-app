import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/disease/disease.dart';
import 'package:fitoagricola/data/models/property_crop/property_crop.dart';

class DiseaseReport {
  int? id;
  int? propertiesCropsId;
  int? interferenceFactorsItemId;
  int? status;
  int? adminId;
  DateTime? openDate;
  int? risk;
  String? incidency;
  PropertyCrop? propertyCrop;
  Disease? disease;
  Admin? admin;

  DiseaseReport({
    this.id,
    this.propertiesCropsId,
    this.interferenceFactorsItemId,
    this.status,
    this.adminId,
    this.openDate,
    this.risk,
    this.incidency,
    this.propertyCrop,
    this.disease,
    this.admin,
  });

  factory DiseaseReport.fromJson(Map<String, dynamic> json) => DiseaseReport(
        id: json["id"],
        propertiesCropsId: json["properties_crops_id"],
        interferenceFactorsItemId: json["interference_factors_item_id"],
        status: json["status"],
        adminId: json["admin_id"],
        openDate: json["open_date"] == null
            ? null
            : DateTime.parse(json["open_date"]),
        risk: json["risk"],
        incidency: json["incidency"],
        propertyCrop: json["property_crop"] == null
            ? null
            : PropertyCrop.fromJson(json["property_crop"]),
        disease:
            json["disease"] == null ? null : Disease.fromJson(json["disease"]),
        admin: json["admin"] == null ? null : Admin.fromJson(json["admin"]),
      );

  static List<DiseaseReport> fromJsonList(List<dynamic> json) {
    List<DiseaseReport> products = [];
    for (var item in json) {
      products.add(DiseaseReport.fromJson(item));
    }
    return products;
  }
}

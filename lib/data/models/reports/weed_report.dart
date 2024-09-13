import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/property_crop/property_crop.dart';
import 'package:fitoagricola/data/models/weed/weed.dart';

class WeedReport {
  int? id;
  int? propertiesCropsId;
  int? interferenceFactorsItemId;
  int? status;
  int? adminId;
  DateTime? openDate;
  int? risk;
  PropertyCrop? propertyCrop;
  Weed? weed;
  Admin? admin;

  WeedReport({
    required this.id,
    required this.propertiesCropsId,
    required this.interferenceFactorsItemId,
    required this.status,
    required this.adminId,
    required this.openDate,
    required this.risk,
    required this.propertyCrop,
    required this.weed,
    required this.admin,
  });

  factory WeedReport.fromJson(Map<String, dynamic> json) => WeedReport(
        id: json["id"],
        propertiesCropsId: json["properties_crops_id"],
        interferenceFactorsItemId: json["interference_factors_item_id"],
        status: json["status"],
        adminId: json["admin_id"],
        openDate: json["open_date"] == null
            ? json["open_date"]
            : DateTime.parse(json["open_date"]),
        risk: json["risk"],
        propertyCrop: json["property_crop"] == null
            ? json["property_crop"]
            : PropertyCrop.fromJson(json["property_crop"]),
        weed: json["weed"] == null ? json["weed"] : Weed.fromJson(json["weed"]),
        admin: json["admin"] == null
            ? json["admin"]
            : Admin.fromJson(json["admin"]),
      );

  static List<WeedReport> fromJsonList(List<dynamic> json) {
    List<WeedReport> products = [];
    for (var item in json) {
      products.add(WeedReport.fromJson(item));
    }
    return products;
  }
}

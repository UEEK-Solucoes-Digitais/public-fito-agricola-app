import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';

class GenericReport {
  int? id;
  int? propertyId;
  int? cropId;
  int? harvestId;
  int? status;
  int? isSubharvest;
  String? subharvestName;
  String? cultureTable;
  String? cultureCodeTable;
  String? emergencyTable;
  String? plantTable;
  String? applicationTable;
  String? productivity;
  String? totalProduction;
  String? stageTable;
  Property? property;
  Crop? crop;
  Harvest? harvest;

  GenericReport({
    required this.id,
    required this.propertyId,
    required this.cropId,
    required this.harvestId,
    required this.status,
    required this.isSubharvest,
    required this.subharvestName,
    required this.cultureTable,
    required this.cultureCodeTable,
    required this.emergencyTable,
    required this.plantTable,
    required this.applicationTable,
    required this.productivity,
    required this.totalProduction,
    required this.stageTable,
    required this.property,
    required this.crop,
    required this.harvest,
  });

  factory GenericReport.fromJson(Map<String, dynamic> json) => GenericReport(
        id: json["id"],
        propertyId: json["property_id"],
        cropId: json["crop_id"],
        harvestId: json["harvest_id"],
        status: json["status"],
        isSubharvest: json["is_subharvest"],
        subharvestName: json["subharvest_name"],
        cultureTable: json["culture_table"].toString(),
        cultureCodeTable: json["culture_code_table"].toString(),
        emergencyTable: json["emergency_table"].toString(),
        plantTable: json["plant_table"].toString(),
        applicationTable: json["application_table"].toString(),
        productivity: json["productivity"],
        totalProduction: json["total_production"],
        stageTable: json["stage_table"],
        property: json["property"] != null
            ? Property.fromJson(json["property"])
            : json["property"],
        crop: json["crop"] != null ? Crop.fromJson(json["crop"]) : json["crop"],
        harvest: json["harvest"] != null
            ? Harvest.fromJson(json["harvest"])
            : json["harvest"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "property_id": propertyId,
        "crop_id": cropId,
        "harvest_id": harvestId,
        "status": status,
        "is_subharvest": isSubharvest,
        "subharvest_name": subharvestName,
        "culture_table": cultureTable,
        "culture_code_table": cultureCodeTable,
        "emergency_table": emergencyTable,
        "plant_table": plantTable,
        "application_table": applicationTable,
        "productivity": productivity,
        "total_production": totalProduction,
        "stage_table": stageTable,
        "property": property?.toJson(),
        "crop": crop?.toJson(),
        "harvest": harvest?.toJson(),
      };

  static List<GenericReport> fromJsonList(List<dynamic> json) {
    List<GenericReport> products = [];
    for (var item in json) {
      products.add(GenericReport.fromJson(item));
    }
    return products;
  }
}

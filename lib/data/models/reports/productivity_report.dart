import 'package:fitoagricola/data/models/data_seed/data_seed.dart';
import 'package:fitoagricola/data/models/property_crop/property_crop.dart';

class ProductivityReport {
  int? id;
  int? propertiesCropsId;
  DateTime? date;
  String? totalProduction;
  String? productivity;
  int? propertyManagementDataSeedId;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? cultureTable;
  String? cultureCodeTable;
  String? datePlant;
  String? productivityPerHectare;
  String? totalProductionPerHectare;
  PropertyCrop? propertyCrop;
  DataSeed? dataSeed;

  ProductivityReport({
    this.id,
    this.propertiesCropsId,
    this.date,
    this.totalProduction,
    this.productivity,
    this.propertyManagementDataSeedId,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.cultureTable,
    this.cultureCodeTable,
    this.datePlant,
    this.productivityPerHectare,
    this.totalProductionPerHectare,
    this.propertyCrop,
    this.dataSeed,
  });

  factory ProductivityReport.fromJson(Map<String, dynamic> json) =>
      ProductivityReport(
        id: json["id"],
        propertiesCropsId: json["properties_crops_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        totalProduction: json["total_production"],
        productivity: json["productivity"],
        propertyManagementDataSeedId: json["property_management_data_seed_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
        cultureTable: json["culture_table"],
        cultureCodeTable: json["culture_code_table"],
        datePlant: json["date_plant"],
        productivityPerHectare: json["productivity_per_hectare"],
        totalProductionPerHectare: json["total_production_per_hectare"],
        propertyCrop: json["property_crop"] == null
            ? null
            : PropertyCrop.fromJson(json["property_crop"]),
        dataSeed: json["data_seed"] == null
            ? null
            : DataSeed.fromJson(json["data_seed"]),
      );

  static List<ProductivityReport> fromJsonList(List<dynamic> json) {
    List<ProductivityReport> reports = [];
    for (var item in json) {
      reports.add(ProductivityReport.fromJson(item));
    }
    return reports;
  }
}

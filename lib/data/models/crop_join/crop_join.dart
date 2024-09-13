import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';

class CropJoin {
  int id;
  int propertyId;
  int harvestId;
  int? isSubharvest;
  String? subharvestName;
  int? cropId;
  Crop? crop;
  Harvest? harvest;
  Property? property;
  String? cultureName;
  String? cultureTable;
  String? emergencyTable;
  String? plantTable;
  String? applicationTable;
  String? color;
  String? productivity;
  String? totalProduction;

  CropJoin({
    required this.id,
    required this.propertyId,
    required this.harvestId,
    this.isSubharvest,
    this.subharvestName,
    this.cropId,
    this.crop,
    this.color,
    this.harvest,
    this.property,
    this.cultureName,
    this.cultureTable,
    this.emergencyTable,
    this.plantTable,
    this.applicationTable,
    this.productivity,
    this.totalProduction,
  });

  factory CropJoin.fromJson(Map<String, dynamic> json) {
    return CropJoin(
      id: json['id'],
      propertyId: json['property_id'],
      harvestId: json['harvest_id'],
      isSubharvest: json['is_subharvest'],
      subharvestName: json['subharvest_name'],
      cropId: json['crop_id'],
      crop: json['crop'] != null ? Crop.fromJson(json['crop']) : null,
      harvest:
          json['harvest'] != null ? Harvest.fromJson(json['harvest']) : null,
      property:
          json['property'] != null ? Property.fromJson(json['property']) : null,
      cultureName: json['culture_name'] ?? null,
      cultureTable: json['culture_table'] ?? null,
      emergencyTable: json['emergency_table'] ?? null,
      plantTable: json['plant_table'] ?? null,
      applicationTable: json['application_table'] ?? null,
      color: json['color'] ?? null,
      productivity: json['productivity'] ?? null,
      totalProduction: json['total_production'] ?? null,
    );
  }

  static List<CropJoin> fromJsonList(List<dynamic> jsonList) {
    List<CropJoin> crops = [];
    for (var json in jsonList) {
      crops.add(CropJoin.fromJson(json));
    }
    return crops;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'harvest_id': harvestId,
      'is_subharvest': isSubharvest,
      'subharvest_name': subharvestName,
      'crop_id': cropId,
      'crop': crop?.toJson(),
      'harvest': harvest?.toJson(),
    };
  }
}

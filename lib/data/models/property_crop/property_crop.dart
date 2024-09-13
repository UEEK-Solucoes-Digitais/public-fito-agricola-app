import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/data_seed/data_seed.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';

class PropertyCrop {
  int? id;
  int? propertyId;
  int? cropId;
  int? harvestId;
  int? isSubharvest;
  String? subharvestName;
  String? cultureTable;
  String? cultureCodeTable;
  String? stageTable;
  Property? property;
  Harvest? harvest;
  Crop? crop;
  List<DataSeed>? dataSeed;

  PropertyCrop({
    this.id,
    this.propertyId,
    this.cropId,
    this.harvestId,
    this.isSubharvest,
    this.subharvestName,
    this.cultureTable,
    this.cultureCodeTable,
    this.stageTable,
    this.property,
    this.harvest,
    this.crop,
    this.dataSeed,
  });

  factory PropertyCrop.fromJson(Map<String, dynamic> json) => PropertyCrop(
        id: json["id"],
        propertyId: json["property_id"],
        cropId: json["crop_id"],
        harvestId: json["harvest_id"],
        isSubharvest: json["is_subharvest"],
        subharvestName: json["subharvest_name"],
        cultureTable: json["culture_table"],
        cultureCodeTable: json["culture_code_table"],
        stageTable: json["stage_table"],
        property: json["property"] == null
            ? json["property"]
            : Property.fromJson(json["property"]),
        harvest: json["harvest"] == null
            ? json["harvest"]
            : Harvest.fromJson(json["harvest"]),
        crop: json["crop"] == null ? json["crop"] : Crop.fromJson(json["crop"]),
        dataSeed: json["data_seed"] != null
            ? List<DataSeed>.from(
                json["data_seed"].map((x) => DataSeed.fromJson(x)))
            : [],
      );
}

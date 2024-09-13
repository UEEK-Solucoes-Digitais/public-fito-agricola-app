import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/data/models/rain_gauge_infos/rain_gauge_infos.dart';

class RainGaugeReport {
  int? id;
  int? propertyId;
  int? cropId;
  int? harvestId;
  int? status;
  int? isSubharvest;
  dynamic subharvestName;
  String? cultureTable;
  String? cultureCodeTable;
  RainGaugeInfos? rainGaugeInfos;
  Property? property;
  Crop? crop;
  Harvest? harvest;

  RainGaugeReport({
    this.id,
    this.propertyId,
    this.cropId,
    this.harvestId,
    this.status,
    this.isSubharvest,
    this.subharvestName,
    this.cultureTable,
    this.cultureCodeTable,
    this.rainGaugeInfos,
    this.property,
    this.crop,
    this.harvest,
  });

  factory RainGaugeReport.fromJson(Map<String, dynamic> json) =>
      RainGaugeReport(
        id: json["id"],
        propertyId: json["property_id"],
        cropId: json["crop_id"],
        harvestId: json["harvest_id"],
        status: json["status"],
        isSubharvest: json["is_subharvest"],
        subharvestName: json["subharvest_name"],
        cultureTable: json["culture_table"],
        cultureCodeTable: json["culture_code_table"],
        rainGaugeInfos: json["rain_gauge_infos"] == null
            ? null
            : RainGaugeInfos.fromJson(json["rain_gauge_infos"]),
        property: json["property"] == null
            ? null
            : Property.fromJson(json["property"]),
        crop: json["crop"] == null ? null : Crop.fromJson(json["crop"]),
        harvest:
            json["harvest"] == null ? null : Harvest.fromJson(json["harvest"]),
      );

  static List<RainGaugeReport> fromJsonList(List<dynamic> json) {
    List<RainGaugeReport> products = [];
    for (var item in json) {
      products.add(RainGaugeReport.fromJson(item));
    }
    return products;
  }
}

import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/data/models/reports/merged_data_input.dart';

class InputReport {
  int? id;
  String? name;
  int? propertyId;
  int? cropId;
  int? harvestId;
  int? status;
  int? isSubharvest;
  String? subharvestName;
  String? cultureTable;
  List<MergedDataInput>? mergedDataInput;
  double? sumDosages;
  Property? property;
  Crop? crop;
  Harvest? harvest;
  String? harvestName;
  double? totalProducts;

  InputReport({
    this.id,
    this.name,
    this.propertyId,
    this.cropId,
    this.harvestId,
    this.status,
    this.isSubharvest,
    this.subharvestName = '',
    this.cultureTable,
    this.mergedDataInput,
    this.sumDosages,
    this.property,
    this.crop,
    this.harvest,
    this.harvestName,
    this.totalProducts,
  });

  factory InputReport.fromJson(Map<String, dynamic> json) => InputReport(
        id: json["id"],
        name: json["name"],
        propertyId: json["property_id"],
        cropId: json["crop_id"],
        harvestId: json["harvest_id"],
        status: json["status"],
        isSubharvest: json["is_subharvest"],
        subharvestName: json["subharvest_name"],
        cultureTable: json["culture_table"],
        mergedDataInput: json["merged_data_input"] == null
            ? []
            : List<MergedDataInput>.from(json["merged_data_input"]!
                .map((x) => MergedDataInput.fromJson(x))),
        sumDosages: json["sum_dosages"]?.toDouble(),
        property: json["property"] == null
            ? null
            : Property.fromJson(json["property"]),
        crop: json["crop"] == null ? null : Crop.fromJson(json["crop"]),
        harvest: json["harvest"] != null && json["harvest"] is! String
            ? Harvest.fromJson(json["harvest"])
            : null,
        harvestName: json["harvest"] != null && json["harvest"] is String
            ? json["harvest"]
            : null,
        totalProducts: json["total_products"]?.toDouble(),
      );

  static List<InputReport> fromJsonList(List<dynamic> json) {
    return json.map<InputReport>((item) => InputReport.fromJson(item)).toList();
  }
}

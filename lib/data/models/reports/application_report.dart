import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';

class ApplicationReport {
  int? id;
  int? propertyId;
  int? cropId;
  int? harvestId;
  int? status;
  int? isSubharvest;
  String? subharvestName;
  String? cultureTable;
  String? cultureCodeTable;
  String? datePlant;
  String? emergencyTable;
  String? plantTable;
  int? applicationNumber;
  String? applicationTable;
  String? applicationDateTable;
  String? daysBetweenPlantAndLastApplication;
  String? daysBetweenPlantAndFirstApplication;
  String? stageTable;
  Property? property;
  Crop? crop;
  Harvest? harvest;

  ApplicationReport({
    this.id,
    this.propertyId,
    this.cropId,
    this.harvestId,
    this.status,
    this.isSubharvest,
    this.subharvestName,
    this.cultureTable,
    this.cultureCodeTable,
    this.datePlant,
    this.emergencyTable,
    this.plantTable,
    this.applicationNumber,
    this.applicationTable,
    this.applicationDateTable,
    this.daysBetweenPlantAndLastApplication,
    this.daysBetweenPlantAndFirstApplication,
    this.stageTable,
    this.property,
    this.crop,
    this.harvest,
  });

  factory ApplicationReport.fromJson(Map<String, dynamic> json) =>
      ApplicationReport(
        id: json["id"],
        propertyId: json["property_id"],
        cropId: json["crop_id"],
        harvestId: json["harvest_id"],
        status: json["status"],
        isSubharvest: json["is_subharvest"],
        subharvestName: json["subharvest_name"],
        cultureTable: json["culture_table"],
        cultureCodeTable: json["culture_code_table"],
        datePlant: json["date_plant"],
        emergencyTable: json["emergency_table"].toString() != '--'
            ? json["emergency_table"].toString()
            : json["emergency_table"],
        plantTable: json["plant_table"].toString() != '--'
            ? json["plant_table"].toString()
            : json["plant_table"],
        applicationNumber: json["application_number"],
        applicationTable: json["application_table"].toString() != '--'
            ? json["application_table"].toString()
            : json["application_table"],
        applicationDateTable: json["application_date_table"],
        daysBetweenPlantAndLastApplication:
            json["days_between_plant_and_last_application"].toString() != '--'
                ? json["days_between_plant_and_last_application"].toString()
                : json["days_between_plant_and_last_application"],
        daysBetweenPlantAndFirstApplication:
            json["days_between_plant_and_first_application"].toString() != '--'
                ? json["days_between_plant_and_first_application"].toString()
                : json["days_between_plant_and_first_application"],
        stageTable: json["stage_table"],
        property: json["property"] == null
            ? null
            : Property.fromJson(json["property"]),
        crop: json["crop"] == null ? null : Crop.fromJson(json["crop"]),
        harvest:
            json["harvest"] == null ? null : Harvest.fromJson(json["harvest"]),
      );

  static List<ApplicationReport> fromJsonList(List<dynamic> json) {
    List<ApplicationReport> reports = [];
    for (var item in json) {
      reports.add(ApplicationReport.fromJson(item));
    }
    return reports;
  }
}

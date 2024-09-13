import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/disease/disease.dart';
import 'package:fitoagricola/data/models/geral_image/geral_image.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/pest/pest.dart';
import 'package:fitoagricola/data/models/weed/weed.dart';

class MonitoringReport {
  int? id;
  int? propertyId;
  int? cropId;
  int? harvestId;
  int? status;
  int? isSubharvest;
  String subharvestName;
  String? cultureTable;
  String? cultureCodeTable;
  List<ManagementData>? managementData;
  Harvest? property;
  Crop? crop;
  Harvest? harvest;

  MonitoringReport({
    this.id,
    this.propertyId,
    this.cropId,
    this.harvestId,
    this.status,
    this.isSubharvest,
    this.subharvestName = '',
    this.cultureTable,
    this.cultureCodeTable,
    this.managementData,
    this.property,
    this.crop,
    this.harvest,
  });

  factory MonitoringReport.fromJson(Map<String, dynamic> json) =>
      MonitoringReport(
        id: json["id"],
        propertyId: json["property_id"],
        cropId: json["crop_id"],
        harvestId: json["harvest_id"],
        status: json["status"],
        isSubharvest: json["is_subharvest"],
        subharvestName:
            json["subharvest_name"] == null ? '' : json["subharvest_name"],
        cultureTable: json["culture_table"],
        cultureCodeTable: json["culture_code_table"],
        managementData: json["management_data"] == null
            ? null
            : ManagementData.fromJsonList(
                json["management_data"],
              ),
        property: json["property"] == null
            ? null
            : Harvest.fromJson(json["property"]),
        crop: json["crop"] == null ? null : Crop.fromJson(json["crop"]),
        harvest:
            json["harvest"] == null ? null : Harvest.fromJson(json["harvest"]),
      );

  static List<MonitoringReport> fromJsonList(List<dynamic> json) {
    List<MonitoringReport> products = [];
    for (var item in json) {
      products.add(MonitoringReport.fromJson(item));
    }
    return products;
  }
}

List<Map<String, dynamic>> mapList(Map<String, dynamic> json) {
  if (json.values.length == 1) return [json];
  return json.entries
      .map(
        (e) => e.value as Map<String, dynamic>,
      )
      .toList();
}

class ManagementData {
  String name;
  List<MonitoringReportStage>? stages;
  List<ManagementDisease>? diseases;
  List<ManagementPest>? pests;
  List<ManagementWeed>? weeds;
  List<ManagementObservation>? observations;

  ManagementData({
    required this.name,
    this.stages,
    this.diseases,
    this.pests,
    this.weeds,
    this.observations,
  });

  factory ManagementData.fromJson(String mapName, Map<String, dynamic> json) =>
      ManagementData(
        name: mapName,
        stages: json["stages"] == null
            ? []
            : List<MonitoringReportStage>.from(
                json["stages"]!.map((x) => MonitoringReportStage.fromJson(x))),
        diseases: json["diseases"] == null
            ? []
            : List<ManagementDisease>.from(
                json["diseases"]!.map((x) => ManagementDisease.fromJson(x))),
        pests: json["pests"] == null
            ? []
            : List<ManagementPest>.from(
                json["pests"]!.map(
                  (x) => ManagementPest.fromJson(x),
                ),
              ),
        weeds: json["weeds"] == null
            ? []
            : List<ManagementWeed>.from(
                json["weeds"]!.map(
                  (x) => ManagementWeed.fromJson(x),
                ),
              ),
        observations: json["observations"] == null
            ? []
            : ManagementObservation.fromJsonList(json["observations"]),
      );

  static List<ManagementData> fromJsonList(Map<String, dynamic> json) {
    List<ManagementData> data = [];
    for (var item in json.entries) {
      data.add(ManagementData.fromJson(item.key, item.value));
    }
    return data;
  }
}

class ManagementObservation {
  int? id;
  String? observations;
  int? risk;
  int? propertiesCropsId;
  DateTime? openDate;
  Admin? admin;
  List<ManagementImage>? images;

  ManagementObservation({
    this.id,
    this.observations,
    this.risk,
    this.propertiesCropsId,
    this.openDate,
    this.admin,
    this.images,
  });

  factory ManagementObservation.fromJson(Map<String, dynamic> json) =>
      ManagementObservation(
        id: json["id"],
        observations: json["observations"],
        risk: json["risk"],
        propertiesCropsId: json["properties_crops_id"],
        openDate: json["open_date"] == null
            ? null
            : DateTime.parse(json["open_date"]),
        admin: json["admin"],
        images: json["images"] == null
            ? []
            : ManagementImage.fromJsonList(json["images"]!),
      );

  static List<ManagementObservation> fromJsonList(List json) {
    List<ManagementObservation> observations = [];
    for (Map<String, dynamic> observation in json) {
      observations.add(ManagementObservation.fromJson(observation));
    }
    return observations;
  }
}

class ManagementDisease {
  int? id;
  int? interferenceFactorsItemId;
  double incidency;
  int? risk;
  int? propertiesCropsId;
  DateTime? openDate;
  Disease? disease;

  ManagementDisease({
    this.id,
    this.interferenceFactorsItemId,
    this.incidency = 0,
    this.risk,
    this.propertiesCropsId,
    this.openDate,
    this.disease,
  });

  factory ManagementDisease.fromJson(Map<String, dynamic> json) =>
      ManagementDisease(
        id: json["id"],
        interferenceFactorsItemId: json["interference_factors_item_id"],
        incidency: double.parse(json["incidency"]),
        risk: json["risk"],
        propertiesCropsId: json["properties_crops_id"],
        openDate: json["open_date"] == null
            ? null
            : DateTime.parse(json["open_date"]),
        disease:
            json["disease"] == null ? null : Disease.fromJson(json["disease"]),
      );
}

class ManagementPest {
  int? id;
  int? interferenceFactorsItemId;
  double incidency;
  double quantityPerMeter;
  double quantityPerSquareMeter;
  int? risk;
  int? propertiesCropsId;
  DateTime? openDate;
  Pest? pest;
  List<ManagementImage>? images;

  ManagementPest({
    this.id,
    this.interferenceFactorsItemId,
    this.incidency = 0,
    this.quantityPerMeter = 0,
    this.quantityPerSquareMeter = 0,
    this.risk,
    this.propertiesCropsId,
    this.openDate,
    this.pest,
    this.images,
  });

  factory ManagementPest.fromJson(Map<String, dynamic> json) => ManagementPest(
        id: json["id"],
        interferenceFactorsItemId: json["interference_factors_item_id"],
        incidency: double.parse(json["incidency"]),
        quantityPerMeter: double.parse(json["quantity_per_meter"]),
        quantityPerSquareMeter: double.parse(json["quantity_per_square_meter"]),
        risk: json["risk"],
        propertiesCropsId: json["properties_crops_id"],
        openDate: json["open_date"] == null
            ? null
            : DateTime.parse(json["open_date"]),
        pest: json["pest"] == null ? null : Pest.fromJson(json["pest"]),
        images: json["images"] == null
            ? []
            : ManagementImage.fromJsonList(json["images"]!),
      );
}

class ManagementWeed {
  int? id;
  int? interferenceFactorsItemId;
  int? risk;
  int? propertiesCropsId;
  DateTime? openDate;
  Weed? weed;
  List<ManagementImage>? images;

  ManagementWeed({
    this.id,
    this.interferenceFactorsItemId,
    this.risk,
    this.propertiesCropsId,
    this.openDate,
    this.weed,
    this.images,
  });

  factory ManagementWeed.fromJson(Map<String, dynamic> json) => ManagementWeed(
        id: json["id"],
        interferenceFactorsItemId: json["interference_factors_item_id"],
        risk: json["risk"],
        propertiesCropsId: json["properties_crops_id"],
        openDate: json["open_date"] == null
            ? null
            : DateTime.parse(json["open_date"]),
        weed: json["weed"] == null ? null : Weed.fromJson(json["weed"]),
        images: json["images"] == null
            ? []
            : ManagementImage.fromJsonList(json["images"]),
      );
}

class Image {
  int? id;
  int? objectId;
  int? type;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? status;

  Image({
    this.id,
    this.objectId,
    this.type,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        objectId: json["object_id"],
        type: json["type"],
        image: json["image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
      );
}

class MonitoringReportStage {
  int? id;
  double? vegetativeAgeValue;
  double? reprodutiveAgeValue;
  String? vegetativeAgeText;
  String? reprodutiveAgeText;
  int? risk;
  int? propertiesCropsId;
  DateTime? openDate;
  List<ManagementImage>? images;

  MonitoringReportStage({
    this.id,
    this.vegetativeAgeValue,
    this.reprodutiveAgeValue,
    this.vegetativeAgeText,
    this.reprodutiveAgeText,
    this.risk,
    this.propertiesCropsId,
    this.openDate,
    this.images,
  });

  factory MonitoringReportStage.fromJson(Map<String, dynamic> json) =>
      MonitoringReportStage(
        id: json["id"],
        vegetativeAgeValue: double.tryParse(json["vegetative_age_value"]),
        reprodutiveAgeValue: double.tryParse(json["reprodutive_age_value"]),
        vegetativeAgeText: json["vegetative_age_text"],
        reprodutiveAgeText: json["reprodutive_age_text"],
        risk: json["risk"],
        propertiesCropsId: json["properties_crops_id"],
        openDate: json["open_date"] == null
            ? null
            : DateTime.parse(json["open_date"]),
        images: json["images"] == null
            ? []
            : ManagementImage.fromJsonList(json["images"]),
      );
}

class ManagementImage {
  int? id;
  int? objectId;
  int? type;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? status;

  ManagementImage({
    this.id,
    this.objectId,
    this.type,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory ManagementImage.fromJson(Map<String, dynamic> json) =>
      ManagementImage(
        id: json["id"],
        objectId: json["object_id"],
        type: json["type"],
        image: json["image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
      );

  static List<ManagementImage> fromJsonList(json) {
    List<ManagementImage> images = [];
    for (Map<String, dynamic> image in json) {
      images.add(ManagementImage.fromJson(image));
    }
    return images;
  }

  GeralImage toGeralImage() {
    return GeralImage(
      id: this.id!,
      image: this.image ?? '',
    );
  }
}

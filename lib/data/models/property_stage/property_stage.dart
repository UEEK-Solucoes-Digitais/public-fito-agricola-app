import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/geral_image/geral_image.dart';

class PropertyStage {
  int? id;
  int? interferenceFactorsItemId;
  double? vegetativeAgeValue;
  String? vegetativeAgeText;
  double? reprodutiveAgeValue;
  String? reprodutiveAgeText;
  int? risk;
  dynamic coordinates;
  dynamic kmlFile;
  int? propertiesCropsId;
  int? adminId;
  Admin? admin;
  List<GeralImage>? images;
  String? openDate;
  dynamic latitude;
  dynamic longitude;

  PropertyStage({
    this.id,
    required this.interferenceFactorsItemId,
    required this.vegetativeAgeValue,
    this.vegetativeAgeText,
    required this.reprodutiveAgeValue,
    this.reprodutiveAgeText,
    required this.risk,
    this.coordinates,
    this.kmlFile,
    this.propertiesCropsId,
    this.adminId,
    this.admin,
    this.images,
    this.openDate,
    this.latitude,
    this.longitude,
  });

  factory PropertyStage.fromJson(Map<String, dynamic> json) {
    return PropertyStage(
      id: json['id'],
      interferenceFactorsItemId: json['interference_factors_item_id'],
      vegetativeAgeValue: json['vegetative_age_value'] != null
          ? double.parse(json['vegetative_age_value'].toString())
          : 0,
      vegetativeAgeText: json['vegetative_age_text'],
      reprodutiveAgeValue: json['reprodutive_age_value'] != null
          ? double.parse(json['reprodutive_age_value'].toString())
          : 0,
      reprodutiveAgeText: json['reprodutive_age_text'],
      risk: json['risk'],
      coordinates: json['coordinates'],
      kmlFile: json['kml_file'],
      propertiesCropsId: json['properties_crops_id'],
      adminId: json['admin_id'],
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
      images: json['images'] != null
          ? GeralImage.fromJsonList(json['images'])
          : null,
      openDate: json['open_date'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // json list
  static List<PropertyStage> fromJsonList(List<dynamic> jsonList) {
    List<PropertyStage> list = [];
    for (var item in jsonList) {
      list.add(PropertyStage.fromJson(item));
    }
    return list;
  }
}

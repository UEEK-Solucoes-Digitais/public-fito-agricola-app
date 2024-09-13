import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/geral_image/geral_image.dart';
import 'package:fitoagricola/data/models/intereference_factor/interference_factor.dart';

class PropertyDisease {
  int? id;
  int? interferenceFactorsItemId;
  double? incidency;
  int? risk;
  dynamic coordinates;
  dynamic kmlFile;
  int? propertiesCropsId;
  int? adminId;
  Admin? admin;
  InterferenceFactor? disease;
  List<GeralImage>? images;
  String? openDate;
  dynamic latitude;
  dynamic longitude;

  PropertyDisease({
    this.id,
    this.interferenceFactorsItemId,
    this.incidency,
    this.risk,
    this.coordinates,
    this.kmlFile,
    this.propertiesCropsId,
    this.adminId,
    this.admin,
    this.disease,
    this.images,
    this.openDate,
    this.latitude,
    this.longitude,
  });

  factory PropertyDisease.fromJson(Map<String, dynamic> json) {
    return PropertyDisease(
      id: json['id'],
      interferenceFactorsItemId: json['interference_factors_item_id'],
      incidency: json['incidency'] != null
          ? double.parse(json['incidency'].toString())
          : 0,
      risk: json['risk'],
      coordinates: json['coordinates'],
      kmlFile: json['kml_file'],
      propertiesCropsId: json['properties_crops_id'],
      adminId: json['admin_id'],
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
      disease: json['disease'] != null
          ? InterferenceFactor.fromJson(json['disease'])
          : null,
      images: json['images'] != null
          ? GeralImage.fromJsonList(json['images'])
          : null,
      openDate: json['open_date'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // json list
  static List<PropertyDisease> fromJsonList(List<dynamic> jsonList) {
    List<PropertyDisease> list = [];
    for (var item in jsonList) {
      list.add(PropertyDisease.fromJson(item));
    }
    return list;
  }
}

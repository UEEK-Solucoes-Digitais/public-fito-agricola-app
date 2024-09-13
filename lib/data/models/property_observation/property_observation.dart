import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/geral_image/geral_image.dart';

class PropertyObservation {
  int? id;
  int? risk;
  String observations;
  dynamic coordinates;
  dynamic kmlFile;
  int? propertiesCropsId;
  int? adminId;
  Admin? admin;
  List<GeralImage>? images;
  String? openDate;
  dynamic latitude;
  dynamic longitude;

  PropertyObservation({
    this.id,
    required this.risk,
    required this.observations,
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

  factory PropertyObservation.fromJson(Map<String, dynamic> json) {
    return PropertyObservation(
      id: json['id'],
      risk: json['risk'],
      observations: json['observations'],
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
  static List<PropertyObservation> fromJsonList(List<dynamic> jsonList) {
    List<PropertyObservation> list = [];
    for (var item in jsonList) {
      list.add(PropertyObservation.fromJson(item));
    }
    return list;
  }
}

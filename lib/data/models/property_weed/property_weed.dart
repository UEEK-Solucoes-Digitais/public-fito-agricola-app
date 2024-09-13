import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/geral_image/geral_image.dart';
import 'package:fitoagricola/data/models/intereference_factor/interference_factor.dart';

class PropertyWeed {
  int? id;
  int? interferenceFactorsItemId;
  int? risk;
  dynamic coordinates;
  dynamic kmlFile;
  int? propertiesCropsId;
  int? adminId;
  Admin? admin;
  InterferenceFactor? weed;
  List<GeralImage>? images;
  String? openDate;
  dynamic latitude;
  dynamic longitude;

  PropertyWeed({
    this.id,
    this.interferenceFactorsItemId,
    this.risk,
    this.coordinates,
    this.kmlFile,
    this.propertiesCropsId,
    this.adminId,
    this.admin,
    this.weed,
    this.images,
    this.openDate,
    this.latitude,
    this.longitude,
  });

  factory PropertyWeed.fromJson(Map<String, dynamic> json) {
    return PropertyWeed(
      id: json['id'],
      interferenceFactorsItemId: json['interference_factors_item_id'],
      risk: json['risk'],
      coordinates: json['coordinates'],
      kmlFile: json['kml_file'],
      propertiesCropsId: json['properties_crops_id'],
      adminId: json['admin_id'],
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
      weed: json['weed'] != null
          ? InterferenceFactor.fromJson(json['weed'])
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
  static List<PropertyWeed> fromJsonList(List<dynamic> jsonList) {
    List<PropertyWeed> list = [];
    for (var item in jsonList) {
      list.add(PropertyWeed.fromJson(item));
    }
    return list;
  }
}

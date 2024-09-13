import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/geral_image/geral_image.dart';
import 'package:fitoagricola/data/models/intereference_factor/interference_factor.dart';

class PropertyPest {
  int? id;
  int? interferenceFactorsItemId;
  double? quantityPerMeter;
  double? quantityPerSquareMeter;
  double incidency;
  int? risk;
  dynamic coordinates;
  dynamic kmlFile;
  int? propertiesCropsId;
  int? adminId;
  Admin? admin;
  InterferenceFactor? pest;
  List<GeralImage>? images;
  String? openDate;
  dynamic latitude;
  dynamic longitude;

  PropertyPest({
    this.id,
    required this.interferenceFactorsItemId,
    required this.quantityPerMeter,
    required this.quantityPerSquareMeter,
    required this.incidency,
    required this.risk,
    this.coordinates,
    this.kmlFile,
    this.propertiesCropsId,
    this.adminId,
    this.admin,
    this.pest,
    this.images,
    this.openDate,
    this.latitude,
    this.longitude,
  });

  factory PropertyPest.fromJson(Map<String, dynamic> json) {
    return PropertyPest(
      id: json['id'],
      interferenceFactorsItemId: json['interference_factors_item_id'],
      quantityPerMeter: json['quantity_per_meter'] != null
          ? double.parse(json['quantity_per_meter'].toString())
          : 0,
      quantityPerSquareMeter: json['quantity_per_square_meter'] != null
          ? double.parse(json['quantity_per_square_meter'].toString())
          : 0,
      incidency: json['incidency'] != null
          ? double.parse(json['incidency'].toString())
          : 0,
      risk: json['risk'],
      coordinates: json['coordinates'],
      kmlFile: json['kml_file'],
      propertiesCropsId: json['properties_crops_id'],
      adminId: json['admin_id'],
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
      pest: json['pest'] != null
          ? InterferenceFactor.fromJson(json['pest'])
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
  static List<PropertyPest> fromJsonList(List<dynamic> jsonList) {
    List<PropertyPest> list = [];
    for (var item in jsonList) {
      list.add(PropertyPest.fromJson(item));
    }
    return list;
  }
}

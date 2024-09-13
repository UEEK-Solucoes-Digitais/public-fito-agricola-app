import 'package:fitoagricola/data/models/property/property.dart';

class Asset {
  int id;
  String name;
  String type;
  double value;
  String? observations;
  String? image;
  String? lifespan;
  String? buy_date;
  String? year;
  String createdAt;
  List<Property> properties;
  String propertiesNames;

  Asset({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.properties,
    required this.propertiesNames,
    this.observations,
    this.image,
    this.lifespan,
    this.buy_date,
    this.year,
    required this.createdAt,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      value:
          json['value'] is String ? double.parse(json['value']) : json['value'],
      observations: json['observations'],
      image: json['image'],
      lifespan: json['lifespan'],
      buy_date: json['buy_date'],
      year: json['year'],
      createdAt: json['created_at'],
      propertiesNames: json['properties_names'],
      properties: Property.fromJsonList(json['properties']),
    );
  }

  // to list
  static List<Asset> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => Asset.fromJson(item)).toList();
  }
}

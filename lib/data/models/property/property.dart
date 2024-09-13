import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/crop_join/crop_join.dart';

class Property {
  final int id;
  final String name;
  final String? city;
  final String? totalArea;
  String? cep;
  String? uf;
  String? street;
  String? neighborhood;
  dynamic number;
  String? complement;
  String? stateSubscription;
  dynamic coordinates;
  String? cnpj;
  int? adminId;
  String? createdAt;
  String? updatedAt;
  int? status;
  Admin? admin;
  List<CropJoin>? crops;

  Property(
      {required this.id,
      required this.name,
      this.city,
      this.totalArea,
      this.cep,
      this.uf,
      this.street,
      this.neighborhood,
      this.number,
      this.complement,
      this.stateSubscription,
      this.coordinates,
      this.cnpj,
      this.adminId,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.admin,
      this.crops});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      totalArea: json['total_area'] ?? '',
      cep: json['cep'] ?? '',
      uf: json['uf'] ?? '',
      street: json['street'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      number: json['number'] ?? '',
      complement: json['complement'] ?? '',
      stateSubscription: json['state_subscription'] ?? '',
      coordinates: json['coordinates'] ?? null,
      cnpj: json['cnpj'] ?? '',
      adminId: json['admin_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      status: json['status'] ?? 0,
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
      crops:
          json['crops'] != null ? CropJoin.fromJsonList(json['crops']) : null,
    );
  }

  static List<Property> fromJsonList(List<dynamic> jsonList) {
    List<Property> properties = [];
    for (var json in jsonList) {
      properties.add(Property.fromJson(json));
    }
    return properties;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'admin': admin?.toJson(),
      'crops': crops?.map((crop) => crop.toJson()).toList(),
      'totalArea': totalArea,
      'cep': cep,
      'uf': uf,
      'street': street,
      'neighborhood': neighborhood,
      'number': number,
      'complement': complement,
      'stateSubscription': stateSubscription,
      'coordinates': coordinates,
      'cnpj': cnpj,
      'adminId': adminId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
    };
  }

  @override
  String toString() {
    return name;
  }
}

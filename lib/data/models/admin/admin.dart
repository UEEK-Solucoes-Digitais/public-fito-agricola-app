import 'package:fitoagricola/data/models/admin_token/admin_token.dart';

class Admin {
  int id;
  String name;
  int? accessLevel;
  dynamic level;
  String? profilePicture;
  String? phone;
  String? email;
  String? cpf;
  String? notificationToken;
  String? country;
  String? city;
  String? state;
  bool? accessMA;
  int? propertiesCount;
  int? actualHarvestId;
  List<AdminToken>? tokens;

  Admin({
    required this.id,
    required this.name,
    required this.accessLevel,
    this.level,
    this.profilePicture,
    this.phone,
    this.email,
    this.cpf,
    this.notificationToken,
    this.country,
    this.city,
    this.state,
    this.accessMA,
    this.tokens,
    this.propertiesCount,
    this.actualHarvestId,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      name: json['name'],
      accessLevel: json['access_level'] ?? 0,
      level: json['level'] ?? '0',
      profilePicture: json['profile_picture'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'] ?? '',
      notificationToken: json['notifications_token'] ?? '',
      actualHarvestId: json['actual_harvest_id'] ?? null,
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      accessMA: json['access_ma'] ?? null,
      propertiesCount: json['properties_count'] ?? null,
      tokens: json['tokens'] != null
          ? AdminToken.fromJsonList(json['tokens'])
          : null,
    );
  }

  // fromJsonList
  static List<Admin> fromJsonList(List list) {
    return list.map((item) => Admin.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accessLevel': accessLevel,
      'level': level,
      'profilePicture': profilePicture,
      'phone': phone,
    };
  }
}

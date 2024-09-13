import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/property_disease/property_disease.dart';
import 'package:fitoagricola/data/models/property_observation/property_observation.dart';
import 'package:fitoagricola/data/models/property_pest/property_pest.dart';
import 'package:fitoagricola/data/models/property_stage/property_stage.dart';
import 'package:fitoagricola/data/models/property_weed/property_weed.dart';

class PropertyMonitoring {
  List<PropertyDisease>? diseases;
  List<PropertyObservation>? observations;
  List<PropertyStage>? stages;
  List<PropertyWeed>? weeds;
  List<PropertyPest>? pests;
  Admin? admin;

  PropertyMonitoring({
    required this.diseases,
    required this.observations,
    required this.stages,
    required this.weeds,
    required this.pests,
    required this.admin,
  });

  factory PropertyMonitoring.fromJson(Map<String, dynamic> json) {
    return PropertyMonitoring(
      diseases: json['diseases'] != null
          ? PropertyDisease.fromJsonList(json['diseases'])
          : null,
      observations: json['observations'] != null
          ? PropertyObservation.fromJsonList(json['observations'])
          : null,
      stages: json['stages'] != null
          ? PropertyStage.fromJsonList(json['stages'])
          : null,
      weeds: json['weeds'] != null
          ? PropertyWeed.fromJsonList(json['weeds'])
          : null,
      pests: json['pests'] != null
          ? PropertyPest.fromJsonList(json['pests'])
          : null,
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
    );
  }
}

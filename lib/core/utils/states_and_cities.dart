import 'dart:convert';
import 'package:flutter/services.dart';

typedef StateCodes = String;

class LocationService {
  static Map<String, dynamic> locations = {};

  static Future<void> loadLocations() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/locations.json');
      locations = json.decode(response) as Map<String, dynamic>;
      print("JSON loaded successfully");
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  static List<Map<String, String>> getStaticStates() {
    if (locations.isEmpty) {
      print("Locations is empty");
      return [];
    }

    final countries = locations['states'].keys.map<Map<String, String>>((key) {
      final stateCode = key as StateCodes;
      final state = locations['states'][stateCode];
      return {
        'id': stateCode,
        'name': state,
        'initial': locations['initials'][stateCode]
      };
    }).toList();

    countries.sort((a, b) => a['name']!.compareTo(b['name']!));
    return countries;
  }

  static List<Map<String, dynamic>> getStaticCities(String stateId) {
    if (locations.isEmpty) {
      print("Locations is empty");
      return [];
    }

    return locations['cities']
        .where((city) => city['state_id'].toString() == stateId)
        .toList();
  }
}

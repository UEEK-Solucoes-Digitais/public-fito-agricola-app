class DataPopulation {
  int id;
  int propertyManagementDataSeedId;
  double seedPerLinearMeter;
  double seedPerSquareMeter;
  double quantityPerHa;
  double emergencyPercentage;
  String emergencyPercentageDate;
  double plantsPerHectare;

  DataPopulation({
    required this.id,
    required this.propertyManagementDataSeedId,
    required this.seedPerLinearMeter,
    required this.seedPerSquareMeter,
    required this.quantityPerHa,
    required this.emergencyPercentage,
    required this.emergencyPercentageDate,
    required this.plantsPerHectare,
  });

  factory DataPopulation.fromJson(Map<String, dynamic> json) {
    return DataPopulation(
      id: json['id'],
      propertyManagementDataSeedId:
          json['property_management_data_seed_id'] != null
              ? json['property_management_data_seed_id']
              : 0,
      seedPerLinearMeter:
          double.parse(json['seed_per_linear_meter'].toString()),
      seedPerSquareMeter:
          double.parse(json['seed_per_square_meter'].toString()),
      quantityPerHa: double.parse(json['quantity_per_ha'].toString()),
      emergencyPercentage:
          double.parse(json['emergency_percentage'].toString()),
      emergencyPercentageDate: json['emergency_percentage_date'],
      plantsPerHectare: double.parse(json['plants_per_hectare'].toString()),
    );
  }

  static List<DataPopulation> fromJsonList(List<dynamic> json) {
    return json.map((e) => DataPopulation.fromJson(e)).toList();
  }
}

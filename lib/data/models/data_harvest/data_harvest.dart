import 'package:fitoagricola/data/models/data_seed/data_seed.dart';

class DataHarvest {
  int id;
  String date;
  int? propertyManagementDataSeedId;
  double totalProduction;
  double productivity;
  DataSeed? dataSeed;
  dynamic systemLog;

  DataHarvest({
    required this.id,
    required this.date,
    this.propertyManagementDataSeedId,
    required this.totalProduction,
    required this.productivity,
    this.dataSeed,
    this.systemLog,
  });

  factory DataHarvest.fromJson(Map<String, dynamic> json) {
    return DataHarvest(
      id: json['id'],
      date: json['date'],
      propertyManagementDataSeedId: json['property_management_data_seed_id'],
      totalProduction: double.parse(json['total_production'].toString()),
      productivity: double.parse(json['productivity'].toString()),
      dataSeed: json['data_seed'] != null
          ? DataSeed.fromJson(json['data_seed'])
          : null,
      systemLog: json['system_log'],
    );
  }

  static List<DataHarvest> fromJsonList(List<dynamic> jsonList) {
    List<DataHarvest> dataHarvests = [];
    for (var json in jsonList) {
      dataHarvests.add(DataHarvest.fromJson(json));
    }
    return dataHarvests;
  }
}

import 'package:fitoagricola/data/models/products/product.dart';

class DataSeed {
  int id;
  int propertiesCropsId;
  double? costPerKilogram;
  double? kilogramPerHa;
  double? spacing;
  double? seedPerLinearMeter;
  double? seedPerSquareMeter;
  double? pms;
  double? quantityPerHa;
  double? area;
  String? date;
  int? productId;
  String? productVariant;
  Product? product;
  dynamic systemLog;

  DataSeed({
    required this.id,
    required this.propertiesCropsId,
    this.costPerKilogram,
    this.kilogramPerHa,
    this.spacing,
    this.seedPerLinearMeter,
    this.seedPerSquareMeter,
    this.pms,
    this.quantityPerHa,
    this.area,
    this.date,
    this.productId,
    this.productVariant,
    this.product,
    this.systemLog,
  });

  factory DataSeed.fromJson(Map<String, dynamic> json) {
    return DataSeed(
      id: json['id'],
      propertiesCropsId: json['properties_crops_id'],
      costPerKilogram: double.tryParse(json['cost_per_kilogram'].toString()),
      kilogramPerHa: double.tryParse(json['kilogram_per_ha'].toString()),
      spacing: double.tryParse(json['spacing'].toString()),
      seedPerLinearMeter:
          double.tryParse(json['seed_per_linear_meter'].toString()),
      seedPerSquareMeter:
          double.tryParse(json['seed_per_square_meter'].toString()),
      pms: double.tryParse(json['pms'].toString()),
      quantityPerHa: double.tryParse(json['quantity_per_ha'].toString()),
      area: double.tryParse(json['area'].toString()),
      date: json['date'],
      productId: json['product_id'],
      productVariant: json['product_variant'],
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      systemLog: json['system_log'],
    );
  }

  static List<DataSeed> fromJsonList(List<dynamic> json) {
    List<DataSeed> dataSeeds = [];
    for (var item in json) {
      dataSeeds.add(DataSeed.fromJson(item));
    }
    return dataSeeds;
  }
}

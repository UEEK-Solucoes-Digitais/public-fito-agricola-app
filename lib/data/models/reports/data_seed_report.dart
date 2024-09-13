import 'package:fitoagricola/data/models/data_population/data_population.dart';
import 'package:fitoagricola/data/models/products/product.dart';
import 'package:fitoagricola/data/models/property_crop/property_crop.dart';

class DataSeedReport {
  int? id;
  int? propertiesCropsId;
  String? costPerKilogram;
  String? kilogramPerHa;
  String? spacing;
  String? seedPerLinearMeter;
  String? seedPerSquareMeter;
  String? pms;
  String? quantityPerHa;
  String? area;
  String? createdAt;
  String? updatedAt;
  int? status;
  DateTime? date;
  int? productId;
  String? productVariant;
  PropertyCrop? propertyCrop;
  List<DataPopulation>? dataPopulation;
  Product? product;

  DataSeedReport({
    this.id,
    this.propertiesCropsId,
    this.costPerKilogram,
    this.kilogramPerHa,
    this.spacing,
    this.seedPerLinearMeter,
    this.seedPerSquareMeter,
    this.pms,
    this.quantityPerHa,
    this.area,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.date,
    this.productId,
    this.productVariant,
    this.propertyCrop,
    this.dataPopulation,
    this.product,
  });

  factory DataSeedReport.fromJson(Map<String, dynamic> json) => DataSeedReport(
        id: json["id"],
        propertiesCropsId: json["properties_crops_id"],
        costPerKilogram: json["cost_per_kilogram"],
        kilogramPerHa: json["kilogram_per_ha"],
        spacing: json["spacing"],
        seedPerLinearMeter: json["seed_per_linear_meter"],
        seedPerSquareMeter: json["seed_per_square_meter"],
        pms: json["pms"],
        quantityPerHa: json["quantity_per_ha"],
        area: json["area"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        productId: json["product_id"],
        productVariant: json["product_variant"],
        propertyCrop: json["property_crop"] == null
            ? null
            : PropertyCrop.fromJson(json["property_crop"]),
        dataPopulation: json["data_population"] == null
            ? []
            : DataPopulation.fromJsonList(json["data_population"]),
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
      );
  static List<DataSeedReport> fromJsonList(List<dynamic> json) {
    List<DataSeedReport> products = [];
    for (var item in json) {
      products.add(DataSeedReport.fromJson(item));
    }
    return products;
  }
}

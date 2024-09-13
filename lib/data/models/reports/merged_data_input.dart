import 'package:fitoagricola/data/models/products/product.dart';

class MergedDataInput {
  int? id;
  int? productId;
  DateTime? date;
  int? type;
  String? dosage;
  int? propertiesCropsId;
  int? status;
  Product? product;
  String? productVariant;
  String? quantityPerHa;
  String? kilogramPerHa;
  double? totalDosage;

  MergedDataInput({
    this.id,
    this.productId,
    this.date,
    this.type,
    this.dosage,
    this.propertiesCropsId,
    this.status,
    this.product,
    this.productVariant,
    this.quantityPerHa,
    this.kilogramPerHa,
    this.totalDosage,
  });

  factory MergedDataInput.fromJson(Map<String, dynamic> json) =>
      MergedDataInput(
        id: json["id"],
        productId: json["product_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        type: json["type"],
        dosage: json["dosage"],
        propertiesCropsId: json["properties_crops_id"],
        status: json["status"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        productVariant: json["product_variant"],
        quantityPerHa: json["quantity_per_ha"],
        kilogramPerHa: json["kilogram_per_ha"],
        totalDosage: double.tryParse(json["total_dosage"].toString()),
      );
}

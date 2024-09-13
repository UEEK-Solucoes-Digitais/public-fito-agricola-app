import 'package:fitoagricola/data/models/products/product.dart';

class DataInput {
  int id;
  int? type;
  String? date;
  double? dosage;
  int? propertyCropId;
  double? dosagePerHectare;
  int? productId;
  Product? product;
  dynamic systemLog;
  int? applicationNumber;

  DataInput({
    required this.id,
    this.type,
    this.date,
    this.dosage,
    this.propertyCropId,
    this.dosagePerHectare,
    this.productId,
    this.product,
    this.systemLog,
    this.applicationNumber,
  });

  factory DataInput.fromJson(Map<String, dynamic> json) {
    return DataInput(
      id: json['id'],
      type: json['type'],
      date: json['date'],
      dosage: json['dosage'] != null
          ? double.parse(json['dosage'].toString())
          : null,
      propertyCropId: json['property_crop_id'],
      dosagePerHectare: json['dosage_per_hectare'] != null
          ? double.parse(json['dosage_per_hectare'].toString())
          : null,
      productId: json['product_id'],
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      systemLog: json['system_log'],
      applicationNumber: json['application_number'],
    );
  }

  static List<DataInput> fromJsonList(List<dynamic> json) {
    List<DataInput> dataInputs = [];
    for (var item in json) {
      dataInputs.add(DataInput.fromJson(item));
    }
    return dataInputs;
  }
}

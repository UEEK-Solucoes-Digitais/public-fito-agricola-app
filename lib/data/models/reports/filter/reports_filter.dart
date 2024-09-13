import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/culture/culture.dart';
import 'package:fitoagricola/data/models/disease/disease.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/pest/pest.dart';
import 'package:fitoagricola/data/models/products/product.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/data/models/weed/weed.dart';

class ReportFilters {
  int? status;
  List<Property>? properties;
  List<Crop>? crops;
  List<Harvest>? harvests;
  List<Culture>? cultures;
  List<Weed>? weeds;
  List<Pest>? pests;
  List<Product>? products;
  List<Disease>? diseases;

  ReportFilters({
    this.status,
    this.properties,
    this.crops,
    this.harvests,
    this.cultures,
    this.weeds,
    this.pests,
    this.products,
    this.diseases,
  });

  factory ReportFilters.fromJson(Map<String, dynamic> json) => ReportFilters(
        status: json["status"],
        properties: json["properties"] == null
            ? []
            : Property.fromJsonList(json["properties"]!),
        crops: json["crops"] == null ? [] : Crop.fromJsonList(json["crops"]!),
        harvests: json["harvests"] == null
            ? []
            : Harvest.fromJsonList(json["harvests"]!),
        cultures: json["cultures"] == null
            ? []
            : List<Culture>.from(
                json["cultures"]!.map(
                  (x) => Culture.fromJson(x),
                ),
              ),
        weeds: json["weeds"] == null ? [] : Weed.fromJsonList(json["weeds"]!),
        pests: json["pests"] == null ? [] : Pest.fromJsonList(json["pests"]),
        products: json["products"] == null
            ? []
            : Product.fromJsonList(json["products"]!),
        diseases: json["diseases"] == null
            ? []
            : Disease.fromJsonList(json["diseases"]!),
      );
}

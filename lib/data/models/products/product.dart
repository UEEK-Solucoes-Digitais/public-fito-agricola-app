class Product {
  int id;
  String name;
  String? extra_column;
  int? type;
  int? objectType;

  Product({
    required this.id,
    required this.name,
    this.extra_column,
    this.type,
    this.objectType,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      extra_column: json['extra_column'],
      type: json['type'],
      objectType: json['object_type'],
    );
  }

  static List<Product> fromJsonList(List<dynamic> json) {
    List<Product> products = [];
    for (var item in json) {
      products.add(Product.fromJson(item));
    }
    return products;
  }
}

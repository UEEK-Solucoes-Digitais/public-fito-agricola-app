class Crop {
  int id;
  String name;
  String? area;
  String? city;
  String? drawArea;
  String? kmlFile;
  int? propertyId;
  String? color;
  dynamic usedArea;
  String? subharvestName;
  int? isSubharvest;
  int? joinId;

  Crop({
    required this.id,
    required this.name,
    this.area,
    this.city,
    this.drawArea,
    this.kmlFile,
    this.propertyId,
    this.color,
    this.usedArea,
    this.subharvestName,
    this.isSubharvest,
    this.joinId,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      area: json['area'] ?? '0',
      city: json['city'] ?? '--',
      drawArea: json['draw_area'] ?? '',
      kmlFile: json['kml_file'] ?? '',
      propertyId: json['property_id'] ?? 0,
      color: json['color'] ?? '',
      usedArea: json['used_area'] ?? 0,
      subharvestName: json['subharvest_name'] ?? null,
      isSubharvest: json['is_subharvest'] ?? null,
      joinId: json['join_id'] ?? null,
    );
  }

  static List<Crop> fromJsonList(List<dynamic> jsonList) {
    List<Crop> crops = [];
    for (var json in jsonList) {
      crops.add(Crop.fromJson(json));
    }
    return crops;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'city': city,
      'draw_area': drawArea,
      'kml_file': kmlFile,
      'property_id': propertyId,
      'color': color,
    };
  }

  @override
  String toString() {
    return name;
  }
}

class Harvest {
  int id;
  String name;
  int? isLastHarvert;

  Harvest({
    required this.id,
    required this.name,
    this.isLastHarvert,
  });

  factory Harvest.fromJson(Map<String, dynamic> json) {
    return Harvest(
      id: json['id'],
      name: json['name'],
      isLastHarvert: json['is_last_harvest'],
    );
  }

  // from json list
  static List<Harvest> fromJsonList(List list) {
    return list.map((item) => Harvest.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isLastHarvert': isLastHarvert,
    };
  }

  @override
  String toString() {
    return name;
  }
}

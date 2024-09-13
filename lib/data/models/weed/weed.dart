class Weed {
  int? id;
  String? name;
  int? status;
  String? observation;

  Weed({
    this.id,
    this.name,
    this.status,
    this.observation,
  });

  factory Weed.fromJson(Map<String, dynamic> json) => Weed(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        observation: json["observation"],
      );

  static List<Weed> fromJsonList(List<dynamic> json) {
    return json.map((e) => Weed.fromJson(e)).toList();
  }

  @override
  String toString() {
    return name ?? '';
  }
}

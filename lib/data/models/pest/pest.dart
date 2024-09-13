class Pest {
  int id;
  String? name;
  int? status;
  dynamic observation;

  Pest({
    required this.id,
    required this.name,
    required this.status,
    required this.observation,
  });

  factory Pest.fromJson(Map<String, dynamic> json) => Pest(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        observation: json["observation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "observation": observation,
      };

  @override
  String toString() {
    return name ?? '';
  }

  static List<Pest> fromJsonList(List<dynamic> json) {
    return json.map((e) => Pest.fromJson(e)).toList();
  }
}

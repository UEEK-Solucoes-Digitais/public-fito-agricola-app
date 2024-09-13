class Disease {
  int? id;
  String? name;
  int? status;
  dynamic observation;

  Disease({
    this.id,
    this.name,
    this.status,
    this.observation,
  });

  factory Disease.fromJson(Map<String, dynamic> json) => Disease(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        observation: json["observation"],
      );

  @override
  String toString() {
    return name ?? '';
  }

  static List<Disease> fromJsonList(List<dynamic> json) {
    return json.map((e) => Disease.fromJson(e)).toList();
  }
}

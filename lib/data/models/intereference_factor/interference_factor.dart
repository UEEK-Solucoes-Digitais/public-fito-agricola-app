class InterferenceFactor {
  int id;
  String name;
  String scientificName;
  String? observation;
  int type;

  InterferenceFactor({
    required this.id,
    required this.name,
    required this.scientificName,
    this.observation,
    required this.type,
  });

  factory InterferenceFactor.fromJson(Map<String, dynamic> json) {
    return InterferenceFactor(
      id: json['id'],
      name: json['name'],
      scientificName: json['scientific_name'],
      observation: json['observation'],
      type: json['type'],
    );
  }

  // json list
  static List<InterferenceFactor> fromJsonList(List<dynamic> jsonList) {
    List<InterferenceFactor> list = [];
    for (var item in jsonList) {
      list.add(InterferenceFactor.fromJson(item));
    }
    return list;
  }
}

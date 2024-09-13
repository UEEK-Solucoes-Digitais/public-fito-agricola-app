class RainGauge {
  int id;
  String date;
  double volume;

  RainGauge({
    required this.id,
    required this.date,
    required this.volume,
  });

  factory RainGauge.fromJson(Map<String, dynamic> json) {
    return RainGauge(
      id: json['id'],
      date: json['date'],
      volume: double.parse(json['volume'].toString()),
    );
  }

  // list json
  static List<RainGauge> listFromJson(List<dynamic> json) {
    List<RainGauge> list = [];
    for (var item in json) {
      list.add(RainGauge.fromJson(item));
    }
    return list;
  }
}

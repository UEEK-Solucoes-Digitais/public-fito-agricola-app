class RainGaugeInfos {
  String? totalVolume;
  String? avgVolume;
  int? rainInterval;
  int? daysWithoutRain;
  int? daysWithRain;

  RainGaugeInfos({
    this.totalVolume,
    this.avgVolume,
    this.rainInterval,
    this.daysWithoutRain,
    this.daysWithRain,
  });

  factory RainGaugeInfos.fromJson(Map<String, dynamic> json) => RainGaugeInfos(
        totalVolume: json["total_volume"] is String
            ? json["total_volume"]
            : json["total_volume"].toString(),
        avgVolume: json["avg_volume"] is String
            ? json["avg_volume"]
            : json["avg_volume"].toString(),
        rainInterval: json["rain_interval"],
        daysWithoutRain: json["days_without_rain"],
        daysWithRain: json["days_with_rain"],
      );

  Map<String, dynamic> toJson() => {
        "total_volume": totalVolume,
        "avg_volume": avgVolume,
        "rain_interval": rainInterval,
        "days_without_rain": daysWithoutRain,
        "days_with_rain": daysWithRain,
      };
}

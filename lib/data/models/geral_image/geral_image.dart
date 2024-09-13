class GeralImage {
  int id;
  String image;

  GeralImage({
    required this.id,
    required this.image,
  });

  factory GeralImage.fromJson(Map<String, dynamic> json) {
    return GeralImage(
      id: json['id'],
      image: json['image'],
    );
  }

  // json list
  static List<GeralImage> fromJsonList(List<dynamic> jsonList) {
    List<GeralImage> list = [];
    for (var item in jsonList) {
      list.add(GeralImage.fromJson(item));
    }
    return list;
  }
}

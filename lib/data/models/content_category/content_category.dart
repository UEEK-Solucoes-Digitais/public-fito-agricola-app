class ContentCategory {
  int id;
  String name;

  ContentCategory({
    this.id = 0,
    this.name = '',
  });

  factory ContentCategory.fromJson(Map<String, dynamic> json) {
    return ContentCategory(
      id: json['id'],
      name: json['name'],
    );
  }

  // list

  static List<ContentCategory> listFromJson(List<dynamic>? json) {
    List<ContentCategory> _list = [];
    if (json != null) {
      for (var i = 0; i < json.length; i++) {
        _list.add(ContentCategory.fromJson(json[i]));
      }
    }
    return _list;
  }
}

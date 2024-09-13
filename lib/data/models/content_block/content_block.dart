import 'package:fitoagricola/data/models/geral_image/geral_image.dart';

class ContentBlock {
  int id;
  int content_id;
  int type;
  String content;
  List<GeralImage> images;

  ContentBlock({
    required this.id,
    required this.content_id,
    required this.type,
    required this.content,
    required this.images,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      id: json['id'],
      content_id: json['content_id'],
      type: json['type'],
      content: json['content'],
      images:
          json['images'] != null ? GeralImage.fromJsonList(json['images']) : [],
    );
  }

  static List<ContentBlock> listFromJson(List<dynamic>? json) {
    List<ContentBlock> _list = [];
    if (json != null) {
      for (var i = 0; i < json.length; i++) {
        _list.add(ContentBlock.fromJson(json[i]));
      }
    }
    return _list;
  }
}

import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/content/content.dart';

class NotificationItem {
  int id;
  int level;
  String title;
  String text;
  int adminId;
  int objectId;
  String type;
  String? subtype;
  String contentText;
  String createdAt;
  String? contentType;
  Admin? adminResponsable;
  int contentInteraction;
  Content? content;
  int isRead;

  NotificationItem({
    required this.id,
    required this.level,
    required this.title,
    required this.text,
    required this.adminId,
    required this.objectId,
    required this.type,
    required this.createdAt,
    required this.adminResponsable,
    required this.contentInteraction,
    required this.content,
    required this.contentText,
    required this.isRead,
    required this.subtype,
    this.contentType,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      level: json['level'],
      title: json['title'],
      text: json['text'],
      adminId: json['admin_id'],
      objectId: json['object_id'],
      type: json['type'],
      subtype: json['subtype'],
      createdAt: json['created_at'],
      contentType: json['content_type'],
      contentText: json['content_text'],
      isRead: json['is_read'],
      contentInteraction: json['content_interaction'],
      adminResponsable: json['admin_responsable'] != null
          ? Admin.fromJson(json['admin_responsable'])
          : null,
      content:
          json['content'] != null ? Content.fromJson(json['content']) : null,
    );
  }

  // json list
  static List<NotificationItem> fromJsonList(List<dynamic> jsonList) {
    List<NotificationItem> items = [];
    for (var item in jsonList) {
      items.add(NotificationItem.fromJson(item));
    }
    return items;
  }
}

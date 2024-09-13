import 'package:fitoagricola/data/models/admin/admin.dart';

class Comment {
  int id;
  int adminId;
  int contentId;
  int? answerId;
  int likes;
  int isLiked;
  String createdAt;
  String text;
  List<Comment> answers;
  Admin admin;
  bool showAll;
  bool showAllResponses;
  bool edit;

  Comment({
    required this.id,
    required this.adminId,
    this.createdAt = '',
    this.showAll = false,
    this.showAllResponses = true,
    this.edit = false,
    required this.contentId,
    this.answerId,
    required this.text,
    required this.admin,
    required this.likes,
    required this.isLiked,
    this.answers = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      adminId: json['admin_id'],
      contentId: json['content_id'],
      answerId: json['answer_id'],
      createdAt: json['created_at'],
      text: json['text'],
      likes: json['likes_count'],
      isLiked: json['is_liked'] != null ? json['is_liked'] : 0,
      admin: Admin.fromJson(json['admin']),
      answers:
          json['answers'] != null ? Comment.fromJsonList(json['answers']) : [],
    );
  }

  static List<Comment> fromJsonList(List<dynamic> json) {
    List<Comment> comments = [];
    for (var item in json) {
      comments.add(Comment.fromJson(item));
    }
    return comments;
  }
}

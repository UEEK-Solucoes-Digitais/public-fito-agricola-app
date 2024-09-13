import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/comments/comments.dart';
import 'package:fitoagricola/data/models/content_block/content_block.dart';
import 'package:fitoagricola/data/models/content_video/content_video.dart';

class Content {
  int id;
  String title;
  String url;
  String image;
  String text;
  String courseCover;
  String mostWatchedCover;
  List<String> categoriesIds;
  int? highlightCategoryId;
  int adminId;
  Admin admin;
  List<ContentBlock> blocks;
  String createdAt;
  int isCourse;
  int isLiked;
  int isSaved;
  int isAvailable;
  int isWatching;
  String watchedSeconds;
  String? videoSeconds;
  int? countVideos;
  int? countFinished;
  int? countFinishedUser;
  int? currentVideo;
  List<Comment> comments;
  List<ContentVideo>? videos;

  Content({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
    required this.courseCover,
    required this.mostWatchedCover,
    required this.categoriesIds,
    this.highlightCategoryId,
    required this.adminId,
    required this.admin,
    required this.text,
    required this.blocks,
    this.createdAt = '',
    required this.isCourse,
    required this.isLiked,
    required this.isSaved,
    required this.isAvailable,
    required this.isWatching,
    required this.watchedSeconds,
    required this.videoSeconds,
    required this.countFinished,
    required this.countFinishedUser,
    required this.countVideos,
    required this.comments,
    required this.currentVideo,
    this.videos,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      url: json['url'],
      image: json['image'],
      courseCover: json['course_cover'],
      mostWatchedCover: json['most_watched_cover'],
      // convert to string
      categoriesIds: json['categories_ids'] != null
          ? (json['categories_ids'] is String
              ? json['categories_ids']
                  .split(',')
                  .map<String>((e) => e.toString())
                  .toList()
              : json['categories_ids']
                  .map<String>((e) => e.toString())
                  .toList())
          : [],
      adminId: json['admin_id'],
      admin: Admin.fromJson(json['admin']),
      blocks: [],
      // blocks: json['blocks'] != null
      //     ? ContentBlock.listFromJson(json['blocks'])
      //     : [],
      createdAt: json['created_at'],
      isCourse: json['is_course'] != null ? json['is_course'] : 0,
      isLiked: json['is_liked'] != null ? json['is_liked'] : 0,
      isSaved: json['is_saved'] != null ? json['is_saved'] : 0,
      currentVideo: json['current_video'] != null ? json['current_video'] : 0,
      highlightCategoryId: json['highlight_category_id'] != null
          ? json['highlight_category_id']
          : null,
      isWatching: json['is_watching'] != null ? json['is_watching'] : 0,
      countFinished:
          json['count_finished'] != null ? json['count_finished'] : 0,
      countFinishedUser:
          json['count_finished_user'] != null ? json['count_finished_user'] : 0,
      countVideos: json['count_videos'] != null ? json['count_videos'] : 0,
      isAvailable: json['is_available'] != null ? json['is_available'] : 1,
      videoSeconds: json['video_seconds'] != null ? json['video_seconds'] : '',
      watchedSeconds:
          json['watched_seconds'] != null ? json['watched_seconds'] : '',
      comments: json['comments'] != null
          ? Comment.fromJsonList(json['comments'])
          : [],
      videos: json['videos'] != null
          ? ContentVideo.fromJsonList(json['videos'])
          : [],
    );
  }

  static List<Content> listFromJson(List<dynamic>? json) {
    List<Content> _list = [];
    if (json != null) {
      for (var i = 0; i < json.length; i++) {
        _list.add(Content.fromJson(json[i]));
      }
    }
    return _list;
  }
}

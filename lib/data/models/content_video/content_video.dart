class ContentVideo {
  int id;
  String title;
  String description;
  String durationTime;
  String videoLink;
  String? watchedSeconds;

  ContentVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.durationTime,
    required this.videoLink,
    this.watchedSeconds,
  });

  factory ContentVideo.fromJson(Map<String, dynamic> json) {
    return ContentVideo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      durationTime: json['duration_time'],
      videoLink: json['video_link'],
      watchedSeconds: json['watched_seconds'],
    );
  }

  // fromJsonList
  static List<ContentVideo> fromJsonList(List<dynamic> jsonList) {
    List<ContentVideo> contentVideos = [];
    jsonList.forEach((json) {
      contentVideos.add(ContentVideo.fromJson(json));
    });
    return contentVideos;
  }
}

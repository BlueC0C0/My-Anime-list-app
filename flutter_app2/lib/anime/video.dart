class Video {
  int id;
  String title;
  String url;
  String thumbnail;

  Video(this.id, this.title, this.url, this.thumbnail);

  factory Video.fromJson(dynamic json) {
    if (json != null) {
      return Video(json['id'], json['title'], json['url'], json['thumbnail']);
    } else {
      print("null");
      return null;
    }
  }
}

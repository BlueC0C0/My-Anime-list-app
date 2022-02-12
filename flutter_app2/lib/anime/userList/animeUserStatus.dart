import 'dart:ui';

import 'listStatus.dart';

class AnimeUserStatus {
  ListStatus status;
  int score;
  int nb_ep_watched;
  bool rewatch;

  AnimeUserStatus(this.status, [this.score, this.nb_ep_watched, this.rewatch]) {
    if (this.score == null) this.score = 0;
  }

  factory AnimeUserStatus.fromJson(dynamic json) {
    if (json != null)
      return AnimeUserStatus(
          getListStatus(json['status'] as String),
          json['score'] as int,
          json['num_episodes_watched'] as int,
          json['is_rewatching'] as bool);
    else
      return AnimeUserStatus(ListStatus.none);
  }

  @override
  String toString() {
    return '{ ${this.status.name}, ${this.score ?? "NC"}, ${this.nb_ep_watched ?? "NC"}, ${this.rewatch ?? "NC"}}';
  }

  Color getColor() {
    return this.status.color;
  }

  static ListStatus getListStatus(String chaine) {
    switch (chaine) {
      case "completed":
        return ListStatus.completed;
      case "dropped":
        return ListStatus.dropped;
      case "on_hold":
        return ListStatus.paused;
      case "plan_to_watch":
        return ListStatus.plan_to_watch;
      case "watching":
        return ListStatus.watching;
      default:
        return ListStatus.none;
    }
  }
}

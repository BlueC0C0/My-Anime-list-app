import 'listStatus.dart';

class AnimeUserStatus {

  ListStatus status;
  int score;
  int nb_ep_watched;
  bool rewatch;


  AnimeUserStatus(this.status,[this.score, this.nb_ep_watched, this.rewatch]);

  factory AnimeUserStatus.fromJson(dynamic json) {
    if(json!=null)
      return AnimeUserStatus(ListStatus.watching.getListStatus(json['status'] as String), json['score'] as int, json['num_episodes_watched'] as int, json['is_rewatching'] as bool);
    else
      return AnimeUserStatus(ListStatus.none);
  }

  @override
  String toString() {
    return '{ ${this.status.name}, ${this.score ?? "NC"}, ${this.nb_ep_watched ?? "NC"}, ${this.rewatch ?? "NC"}}';
  }

}


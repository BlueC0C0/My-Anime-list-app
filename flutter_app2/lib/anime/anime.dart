import 'package:flutter_app2/anime/broadcast.dart';
import 'package:flutter_app2/anime/picture.dart';
import 'package:flutter_app2/anime/season.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:http/http.dart' as http;
import 'animeUserStatus.dart';

class Anime {
  int id; //ok
  dynamic score; //ok
  String title; //ok
  String status;
  String type; //ok
  Picture mainImage; //ok

  String synopsis; //ok
  Season season;
  AnimeUserStatus statusList; //SET ON NONE if not in list
  int nb_episodes;
  int average_duration;
  Broadcast broadcast;
  List<String> titles; //TODO is available where is not in list
  List<Picture> images; //
  List<String> genres;
  List<Anime> related_anime; //OK
  List<Anime> recommandations; //OK
  List<String> studios;
  int rank;
  bool nsfw = false;

  bool isComplet;

  Anime(
      this.id, this.score, this.title, this.status, this.type, this.mainImage);

  factory Anime.fromJson(dynamic json) {
    Anime temp = new Anime(
        json['id'] as int,
        json['mean'] as dynamic,
        json['title'] as String,
        json['status'] as String,
        json['media_type'] as String,
        Picture.fromJson(json['main_picture']));

    temp.synopsis = json['synopsis'] as String ?? "";

    temp.season = Season.fromJson(json['start_season']);

    temp.statusList = AnimeUserStatus.fromJson(json['my_list_status']);

    temp.nb_episodes = json['num_episodes'] as int ?? 0;

    temp.average_duration =
        ((json['average_episode_duration'] as int) ?? 0 / 60).round();

    temp.broadcast = Broadcast.fromJson(json['broadcast']);

    temp.rank = json['rank'] as int ?? 0;

    if (json['nsfw'] as String == "white" || json['nsfw'] == null)
      temp.nsfw = false;
    else
      temp.nsfw = true;

    temp.related_anime = [];
    temp.images = [];
    temp.recommandations = [];

    List list = json['studios'] as List ?? [];
    temp.studios = [];
    for (int i = 0; i < list.length; i++) {
      temp.studios.add(list.elementAt(i)['name'] as String);
    }

    list = json['genres'] as List ?? [];
    temp.genres = [];
    for (int i = 0; i < list.length; i++) {
      temp.genres.add(list.elementAt(i)['name'] as String);
    }
    temp.isComplet = false;
    return temp;
  }

  completeInformations(dynamic json) {
    List list = json['pictures'] as List ?? new List();
    this.images = new List<Picture>();
    for (int i = 0; i < list.length; i++) {
      this.images.add(Picture.fromJson(list.elementAt(i)));
    }

    list = json['related_anime'] as List ?? new List();
    this.related_anime = new List<Anime>();
    for (int i = 0; i < list.length; i++) {
      this.related_anime.add(Anime.fromJson(list.elementAt(i)['node']));
    }

    list = json['recommendations'] as List ?? new List();
    this.recommandations = new List<Anime>();
    for (int i = 0; i < list.length; i++) {
      this.recommandations.add(Anime.fromJson(list.elementAt(i)['node']));
    }

    this.isComplet = true;
  }

  getRank() {
    if (this.score == null)
      return 0;
    else
      return this.score;
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.score}, ${this.title}, ${this.status}, ${this.type}, ${this.mainImage}}';
  }

  Future<void> changeNbEpisode(int val) async {
    Authentication auth = Authentication.getSingleton();
    Map<String, String> header = {
      'Authorization': auth.token.token_type + ' ' + auth.token.access_token
    };

    Map<String, String> data = {'num_watched_episodes': (val).toString()};

    var result = await http.put(
        Uri.https(
            'api.myanimelist.net',
            '/v2/anime/' + this.id.toString() + '/my_list_status',
        ),
        headers: header,
        body: data
    );
    print("fin de la requete " + this.statusList.nb_ep_watched.toString());
    this.statusList.nb_ep_watched = val;
  }
}

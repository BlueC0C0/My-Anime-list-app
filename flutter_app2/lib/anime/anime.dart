import 'dart:ui';

import 'package:flutter_app2/anime/Broadcast.dart';
import 'package:flutter_app2/anime/picture.dart';
import 'package:flutter_app2/anime/season.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:http/http.dart' as http;
import 'AiringStatus.dart';
import 'MediaType.dart';
import 'Nsfw.dart';
import 'userList/animeUserStatus.dart';

class Anime {
  //not nullable
  static final int NULL_NUMBER_VALUE = -1;
  static final String NULL_STRING_VALUE = "NC";
  int id; //dont show
  String title;
  int numberOfUser;
  int numScoringUsers;
  Map<int, String> genres; //peut etre remplacer par une map
  MediaType mediaType;
  AiringStatus airingStatus;
  int numberOfEpisodes;
  Map<int, String> studios; //peut etre remplacer par une map

  //nullable
  String synopsis;
  double mean;
  int rank;
  int popularity;
  DateTime startDate;
  DateTime endDate;
  AnimeUserStatus userStatus;
  Picture mainImage;
  Nsfw nsfw;
  Season airingSeason;
  Broadcast broadcast;
  Duration averageEpisodeDuration;

  List<String> aternativeTitles;
  List<Picture> alternativeImages;
  List<Anime> recommendations;

  Anime();

  void printWrapped(String text) {}

  factory Anime.fromJson(dynamic json) {
    Anime temp = new Anime();

    temp.id = json["id"];
    temp.title = json["title"];
    temp.numberOfUser = json["num_list_users"];
    temp.numScoringUsers = json["num_scoring_users"];
    temp.numberOfEpisodes = json["num_episodes"];

    temp.mediaType = MediaTypeUtil.getFromFormatedString(json["media_type"]) ??
        MediaType.unknown;
    temp.airingStatus = AiringStatusUtil.getFromFormatedString(json["status"]);

    temp.genres = new Map();
    if (json["genres"] != null) {
      for (dynamic subJson in json["genres"]) {
        temp.genres[subJson["id"]] = subJson["name"];
      }
    }

    temp.studios = new Map();
    if (json["studios"] != null) {
      for (dynamic subJson in json["studios"]) {
        temp.studios[subJson["id"]] = subJson["name"];
      }
    }

    temp.recommendations = [];
    if (json["recommendations"] != null) {
      for (dynamic subJson in json["recommendations"]) {
        //print(subJson);
        temp.recommendations.add(Anime.fromJson(subJson["node"]));
      }
    }

    temp.synopsis = json["synopsis"] ?? NULL_STRING_VALUE;
    temp.mean = (json["mean"] ?? NULL_NUMBER_VALUE) + 0.0;
    temp.rank = json["rank"] ?? NULL_NUMBER_VALUE;
    temp.popularity = json["popularity"] ?? NULL_NUMBER_VALUE;

    String date = json["start_date"].toString() ?? "2000-1-1";
    if (date == "null") {
      date = "2000-1-1";
    }

    int year, month, day;
    year = int.parse(date.split("-")[0]);
    if (date.split("-").length < 2)
      month = 0;
    else
      month = int.parse(date.split("-")[1]);
    if (date.split("-").length < 3)
      day = 0;
    else
      day = int.parse(date.split("-")[2]);
    temp.startDate = DateTime(year, month, day);

    date = json["end_date"].toString() ?? "2000-1-1";
    if (date == "null") {
      date = "2000-1-1";
    }

    year = int.parse(date.split("-")[0]);
    month = int.parse(date.split("-")[1] ?? 1);
    day = int.parse(date.split("-")[2] ?? 1);
    temp.endDate = DateTime(year, month, day);

    temp.userStatus = AnimeUserStatus.fromJson(json["my_list_status"]);
    temp.mainImage = new Picture.fromJson(json["main_picture"]);
    temp.nsfw = NsfwUtil.getFromFormatedString(json["nsfw"] ?? "");
    temp.airingSeason = new Season.fromJson(json["start_season"]);
    temp.broadcast = new Broadcast.fromJson(json["broadcast"]);
    temp.averageEpisodeDuration =
        new Duration(minutes: json["average_episode_duration"] ?? 0);

    return temp;
  }

  Map<String, String> changeNbEpisode(int newValue) {
    Map<String, String> data = {'num_watched_episodes': (newValue).toString()};
    //this.userStatus.nb_ep_watched = newValue;
    return data;
  }

  Map<String, String> changeListStatus(ListStatus newStatus) {
    Map<String, String> data = {'status': newStatus.encodeName};
    //this.userStatus.status = newStatus;
    return data;
  }

  Future<void> updateAnimeDatas(Map<String, String> data) async {
    Authentication auth = Authentication.getSingleton();
    Map<String, String> header = {
      'Authorization': auth.token.token_type + ' ' + auth.token.access_token
    };

    var result = await http.put(
        Uri.https(
          'api.myanimelist.net',
          '/v2/anime/' + this.id.toString() + '/my_list_status',
        ),
        headers: header,
        body: data);

    print("retour de update anime");
    print(result.body);
  }

  String formatedStartDate() {
    return startDate.day.toString() +
        "/" +
        startDate.month.toString() +
        "/" +
        startDate.year.toString();
  }

  String formatedEndDate() {
    return endDate.day.toString() +
        "/" +
        endDate.month.toString() +
        "/" +
        endDate.year.toString();
  }
}

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/anime/Broadcast.dart';
import 'package:flutter_app2/anime/picture.dart';
import 'package:flutter_app2/anime/season.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:http/http.dart' as http;
import 'AiringStatus.dart';
import 'Classification.dart';
import 'MediaType.dart';
import 'Nsfw.dart';
import 'animeUserStatus.dart';

class Anime {
  //not nullable
  static final int NULL_NUMBER_VALUE = -1;
  static final String NULL_STRING_VALUE = "NC";
  int id;
  String title;
  int numberOfUser;
  int numScoringUsers;
  Map<int,String> genres;//peut etre remplacer par une map
  MediaType mediaType;
  AiringStatus airingStatus;
  int numberOfEpisodes;
  Map<int,String> studios;//peut etre remplacer par une map

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



  Anime();

  factory Anime.fromJson(dynamic json) {
    Anime temp = new Anime();

    temp.id = json["id"];
    temp.title = json["title"];
    temp.numberOfUser = json["num_list_users"];
    temp.numScoringUsers = json["num_scoring_users"];
    temp.numberOfEpisodes = json["num_episodes"];

    temp.mediaType = MediaTypeUtil.getFromFormatedString(json["media_type"]);
    temp.airingStatus = AiringStatusUtil.getFromFormatedString(json["status"]);

    temp.genres = new Map();
    for(dynamic subJson in json["genres"]) {
      temp.genres[subJson["id"]] = subJson["name"];
    }
    temp.studios = new Map();
    for(dynamic subJson in json["studios"]) {
      temp.studios[subJson["id"]] = subJson["name"];
    }




    temp.synopsis = json["synopsis"] ?? NULL_STRING_VALUE;
    temp.mean = (json["mean"] ?? NULL_NUMBER_VALUE)+0.0;
    temp.rank = json["rank"]  ?? NULL_NUMBER_VALUE;
    temp.popularity = json["popularity"] ?? NULL_NUMBER_VALUE;
    //temp.startDate = json["start_date"] ?? null;
    //temp.endDate = json["end_date"] ?? null;
    temp.userStatus = AnimeUserStatus.fromJson(json["my_list_status"]);
    temp.mainImage = new Picture.fromJson(json["main_picture"]);
    temp.nsfw = NsfwUtil.getFromFormatedString(json["nsfw"] ?? "");
    temp.airingSeason = new Season.fromJson(json["start_season"]);
    temp.broadcast = new Broadcast.fromJson(json["broadcast"]);
    temp.averageEpisodeDuration = new Duration(minutes: json["average_episode_duration"] ?? 0);



    return temp;
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
    print("fin de la requete " + this.userStatus.nb_ep_watched.toString());
    this.userStatus.nb_ep_watched = val;
  }
}


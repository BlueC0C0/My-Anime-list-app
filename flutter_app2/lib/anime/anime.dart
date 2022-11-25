import 'package:flutter_app2/anime/Broadcast.dart';
import 'package:flutter_app2/anime/TitleVersion.dart';
import 'package:flutter_app2/anime/picture.dart';
import 'package:flutter_app2/anime/season.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';
import 'package:flutter_app2/anime/video.dart';
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
  //DateTime startDate;
  //DateTime endDate;
  String startDate;
  String endDate;
  AnimeUserStatus userStatus;
  Picture mainImage;
  Nsfw nsfw;
  Season airingSeason;
  Broadcast broadcast;
  Duration averageEpisodeDuration;

  Map<String, String> alternativeTitles;
  List<String> synonyms;
  List<Picture> alternativeImages;
  List<Anime> recommendations;
  List<Video> videos;

  Anime();

  void printWrapped(String text) {}

  factory Anime.fromJson(dynamic json) {
    Anime temp = new Anime();

    temp.id = json["id"];
    temp.title = json["title"];
    temp.numberOfUser = json["num_list_users"];
    temp.numScoringUsers = json["num_scoring_users"];
    temp.numberOfEpisodes = json["num_episodes"];
    temp.synopsis = json["synopsis"] ?? NULL_STRING_VALUE;
    temp.mean = (json["mean"] ?? NULL_NUMBER_VALUE) + 0.0;
    temp.rank = json["rank"] ?? NULL_NUMBER_VALUE;
    temp.popularity = json["popularity"] ?? NULL_NUMBER_VALUE;

    temp.mediaType = MediaTypeUtil.getFromFormatedString(json["media_type"]) ??
        MediaType.unknown;
    temp.airingStatus = AiringStatus.getFromFormatedString(json["status"]);

    temp.userStatus = AnimeUserStatus.fromJson(json["my_list_status"]);
    temp.mainImage = new Picture.fromJson(json["main_picture"]);
    temp.nsfw = NsfwUtil.getFromFormatedString(json["nsfw"] ?? "");
    temp.airingSeason = new Season.fromJson(json["start_season"]);
    temp.broadcast = new Broadcast.fromJson(json["broadcast"]);
    temp.averageEpisodeDuration =
        new Duration(minutes: json["average_episode_duration"] ?? 0);

    ///////// Genres /////////
    temp.genres = new Map();
    if (json["genres"] != null) {
      for (dynamic subJson in json["genres"]) {
        temp.genres[subJson["id"]] = subJson["name"];
      }
    }

    ///////// Studios /////////
    temp.studios = new Map();
    if (json["studios"] != null) {
      for (dynamic subJson in json["studios"]) {
        temp.studios[subJson["id"]] = subJson["name"];
      }
    }

    ///////// Recommendations /////////
    temp.recommendations = [];
    if (json["recommendations"] != null) {
      for (dynamic subJson in json["recommendations"]) {
        //print(subJson);
        temp.recommendations.add(Anime.fromJson(subJson["node"]));
      }
    }

    ///////// Video /////////
    temp.videos = [];
    if (json["videos"] != null) {
      for (dynamic subJson in json["videos"]) {
        temp.videos.add(Video.fromJson(subJson));
      }
    }

    ///////// Alternative Images /////////
    temp.alternativeImages = [];
    if (json['pictures'] != null) {
      for (dynamic subjson in json['pictures']) {
        temp.alternativeImages.add(Picture.fromJson(subjson));
      }
    }

    ///////// Alternatives titles /////////
    temp.alternativeTitles = Map();
    temp.synonyms = [];
    if (json['alternative_titles'] != null) {
      dynamic subjson = json['alternative_titles'];
      if (subjson['synonyms'] != null) {
        for (String synonym in subjson['synonyms']) {
          temp.synonyms.add(synonym);
        }
      }
      if (subjson['en'] != null) {
        temp.alternativeTitles["en"] = subjson['en'];
      }

      if (subjson['ja'] != null) {
        temp.alternativeTitles["ja"] = subjson['ja'];
      }
    }

    temp.startDate = json["start_date"].toString() ?? "null";
    temp.endDate = json["end_date"].toString() ?? "null";
    /*
    ///////// Date debut /////////
    String date = json["start_date"].toString();
    print("date de debut : " + date);
    if (date == null || date == "null") {
      temp.startDate = null;
    } else {
      print("c'est pas null");
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
    }

    ///////// Date fin /////////
    date = json["end_date"].toString();
    print("date de fin : " + date);
    if (date == null || date == "null") {
      temp.endDate = null;
    } else {
      int year, month, day;
      print("c'est pas null");
      year = int.parse(date.split("-")[0]);
      month = int.parse(date.split("-")[1] ?? 1);
      day = int.parse(date.split("-")[2] ?? 1);
      temp.endDate = DateTime(year, month, day);
    }*/

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

  Map<String, String> changeScore(int newScore) {
    Map<String, String> data = {'score': newScore.toString()};
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
    if (startDate == "null") {
      return "Unknown";
    }
    return startDate;
    /*return startDate.day.toString() +
        "/" +
        startDate.month.toString() +
        "/" +
        startDate.year.toString();*/
  }

  String formatedEndDate() {
    if (endDate == "null") {
      return "Unknown";
    }
    return endDate;
    /*return endDate.day.toString() +
        "/" +
        endDate.month.toString() +
        "/" +
        endDate.year.toString();*/
  }

  bool hasVersion(TitleVersion version) {
    switch (version) {
      case TitleVersion.ENGLISH:
        return this.alternativeTitles.containsKey("en") &&
            this.alternativeTitles["en"].toString().trim() != "";
      case TitleVersion.JAPANESE:
        return this.alternativeTitles.containsKey("ja") &&
            this.alternativeTitles["ja"].toString().trim() != "";
      case TitleVersion.SYNONYMS:
        return this.synonyms.length != 0;
      default:
        return true;
    }
  }

  String getTitle(TitleVersion version) {
    if (version == TitleVersion.ENGLISH && hasVersion(version)) {
      return this.alternativeTitles["en"];
    }
    if (version == TitleVersion.JAPANESE && hasVersion(version)) {
      return this.alternativeTitles["ja"];
    }
    if (version == TitleVersion.SYNONYMS && hasVersion(version)) {
      String retour = this.synonyms.first;
      for (String title in this.synonyms) {
        if (title.length < retour.length) {
          retour = title;
        }
      }
      return retour;
    }

    return this.title;
  }

  List<String> getTitles() {
    List<String> retour = [];
    retour.add(title.toLowerCase());
    if (hasVersion(TitleVersion.ENGLISH)) {
      retour.add(alternativeTitles["en"].toLowerCase());
    }
    if (hasVersion(TitleVersion.JAPANESE)) {
      retour.add(alternativeTitles["ja"].toLowerCase());
    }
    if (hasVersion(TitleVersion.SYNONYMS)) {
      for (String title in this.synonyms) {
        retour.add(title.toLowerCase());
      }
    }
    return retour;
  }

  List<Picture> getImages() {
    List<Picture> retour = [];

    retour.add(this.mainImage);
    retour.addAll(this.alternativeImages);

    return retour;
  }

  Anime clone() {
    Anime clone = Anime();
    clone.airingSeason = this.airingSeason;
    clone.alternativeImages = this.alternativeImages.toList();
    clone.alternativeTitles = Map.from(this.alternativeTitles);
    clone.averageEpisodeDuration = this.averageEpisodeDuration;
    clone.broadcast = this.broadcast;
    clone.endDate = this.endDate;
    clone.genres = Map.from(this.genres);
    clone.id = this.id;
    clone.mainImage = this.mainImage;
    clone.mean = this.mean;
    clone.mediaType = this.mediaType;
  }
}

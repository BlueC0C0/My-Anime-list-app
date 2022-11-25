import 'package:flutter_app2/anime/Seasons.dart';
import 'package:flutter_app2/anime/User.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:web_scraper/web_scraper.dart';

class AnimeRequest {
  static chargerList(Token token, ListStatus page, String user) async {
    print("recuperation des données...");
    //Map<String, String> header = {
    //  'Authorization': token.token_type+' '+token.access_token
    //};
    Map<String, String> header = {
      'Authorization':
          "Bearer " + Authentication.getSingleton().token.access_token
    };
    print(">" + page.encodeName);
    var result = await executeRequete(
        Uri.https('api.myanimelist.net', '/v2/users/' + user + '/animelist', {
          'status': page.encodeName,
          'limit': '1000',
          'fields':
              'id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,studios,background,related_anime,related_manga,recommendations,studios,statistics'
        }),
        header);
    //print(result);
    if (jsonDecode(result)['data'] != null) {
      var jsonAnimeList = jsonDecode(result)['data'] as List;
      List<Anime> animeList = jsonAnimeList
          .map((animeJson) => Anime.fromJson(animeJson['node']))
          .toList();
      return animeList;
    } else {
      print("error requete charger list : ");
      print(result);
      return null;
    }
  }

  static chargerSaison(Token token, int annee, Seasons season) async {
    Map<String, String> header = {
      'Authorization':
          "Bearer " + Authentication.getSingleton().token.access_token
    };

    var result = await executeRequete(
        Uri.https(
            'api.myanimelist.net',
            '/v2/anime/season/' + annee.toString() + '/' + season.displayName(),
            {
              'limit': '100',
              'sort': 'anime_num_list_users',
              'fields':
                  'id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics'
            }),
        header);

    if (jsonDecode(result)['data'] != null) {
      var jsonAnimeList = jsonDecode(result)['data'] as List;
      List<Anime> animeList = jsonAnimeList
          .map((animeJson) => Anime.fromJson(animeJson['node']))
          .toList();
      return animeList;
    } else {
      print("error requete charger list : ");
      print(result);
      return null;
    }
  }

  static Future<dynamic> chargerAnimeDetail(Token token, int id) async {
    print("recuperation des données...");
    Map<String, String> header = {
      'Authorization':
          "Bearer " + Authentication.getSingleton().token.access_token
    };
    var result = await executeRequete(
        Uri.https('api.myanimelist.net', '/v2/anime/' + id.toString(), {
          'fields':
              'id,videos,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics'
        }),
        header);

    if (jsonDecode(result)['id'] != null) {
      return jsonDecode(result);
    } else
      return null;
  }

  static Future<dynamic> chargerUserDetail(Token token) async {
    print("recuperation des données...");
    Map<String, String> header = {
      'Authorization':
          "Bearer " + Authentication.getSingleton().token.access_token
    };
    var result = await executeRequete(
        Uri.https(
            'api.myanimelist.net', '/v2/users/@me', {'fields': 'myfriends'}),
        header);
    print(result);
    if (jsonDecode(result)['id'] != null) {
      return jsonDecode(result);
    } else
      return null;
  }

  static Future<List<User>> chargerFriends(Token token) async {
    print("recuperation des données...");
    Map<String, String> header = {};
    var result = await executeRequete(
        Uri.https('myanimelist.net', '/profile/RomainC'), header);
    final webScrapper = WebScraper();
    webScrapper.loadFromString(result);
    final friends =
        webScrapper.getElement("a.icon-friend", ["title", "data-bg"]);
    final titleList = <User>[];
    friends.forEach((element) {
      final title = element['title'];
      final urlImage = element['attributes']["data-bg"];
      titleList.add(User('$title', '$title', '$urlImage'));
    });
    return titleList;
  }

  static executeRequete(Uri url, Map<String, String> header) async {
    var result = await http.get(url, headers: header);
    //print("fin de la requete");
    //print(result.body);
    return result.body;
  }
}

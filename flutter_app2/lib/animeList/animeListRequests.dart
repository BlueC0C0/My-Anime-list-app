

import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'animeUI.dart';



class AnimeRequest {



  static chargerList(Token token,String page) async {
    print("recuperation des données...");
    //Map<String, String> header = {
    //  'Authorization': token.token_type+' '+token.access_token
    //};
    Map<String, String> header = {
      'Authorization': "Bearer "+Authentication.getSingleton().token.access_token
    };

    var result =  await executeRequete(
        Uri.https(
            'api.myanimelist.net',
            '/v2/users/@me/animelist',
            {
              'status': page,
              'limit': '100',
              'fields': 'id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics'
            }
        ),
        header
    );

    if(jsonDecode(result)['data']!=null) {
      var jsonAnimeList = jsonDecode(result)['data'] as List;
      List<Anime> animeList = jsonAnimeList.map((animeJson) =>
          Anime.fromJson(animeJson['node'])).toList();
      return animeList;
    } else
      return null;
  }

  static chargerSaison(Token token) async {
    Map<String, String> header = {
      'Authorization': "Bearer "+Authentication.getSingleton().token.access_token
    };


    var result =  await executeRequete(
        Uri.https(
            'api.myanimelist.net',
            '/v2/anime/season/2020/',
            {
              'limit': '100',
              'fields': 'id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics'
            }
        ),
        header
    );

    if(jsonDecode(result)['data']!=null) {
      var jsonAnimeList = jsonDecode(result)['data'] as List;
      List<Anime> animeList = jsonAnimeList.map((animeJson) =>
          Anime.fromJson(animeJson['node'])).toList();
      return animeList;
    } else
      return null;
  }

  static chargerAnimeDetail(Token token, int id) async {
    print("recuperation des données...");
    Map<String, String> header = {
      'Authorization': "Bearer "+Authentication.getSingleton().token.access_token
    };

    var result =  await executeRequete(
      Uri.https(
        'api.myanimelist.net',
        '/v2/anime/'+id.toString(),
        {
        'fields': 'id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics'
        }
      ),
        header
    );

    if(jsonDecode(result)['id']!=null) {
      return jsonDecode(result);
    }
    else
      return null;

  }


  static executeRequete(Uri url, Map<String, String> header) async {
    var result =  await http.get(
      url,
      headers:  header
    );
    print("fin de la requete");
    print(result.body);
    return result.body;
  }

}

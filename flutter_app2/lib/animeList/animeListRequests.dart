

import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/token/token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'animeUI.dart';



class AnimeList {



  chargerList(Token token,String page) async {
    print("recuperation des données...");
    Map<String, String> header = {
      'Authorization': token.token_type+' '+token.access_token
    };

    var result =  await http.get(
        'https://api.myanimelist.net/v2/users/@me/animelist?status='+page+'&limit=100&fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics',
        headers: header
    );
    print("fin de la requete");


    if(jsonDecode(result.body)['data']!=null) {
      var jsonAnimeList = jsonDecode(result.body)['data'] as List;
      List<Anime> animeList = jsonAnimeList.map((animeJson) =>
          Anime.fromJson(animeJson['node'])).toList();
      return animeList;
    }
    else
      return null;
  }

  chargerSaison(Token token) async {
    Map<String, String> header = {
      'Authorization': token.token_type+' '+token.access_token
    };

    var result =  await http.get(
        'https://api.myanimelist.net/v2/anime/season/2020/fall?limit=100&fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics',
        headers: header
    );
    print("fin de la requete");

    if(jsonDecode(result.body)['data']!=null) {
      var jsonAnimeList = jsonDecode(result.body)['data'] as List;
      List<Anime> animeList = jsonAnimeList.map((animeJson) =>
          Anime.fromJson(animeJson['node'])).toList();
      return animeList;
    }
    else
      return null;
  }

  chargerAnimeDetail(Token token, int id) async {
    print("recuperation des données...");
    Map<String, String> header = {
      'Authorization': token.token_type+' '+token.access_token
    };

    var result =  await http.get(
        'https://api.myanimelist.net/v2/anime/'+id.toString()+'?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics',
        headers: header
    );
    print("fin de la requete");


    if(jsonDecode(result.body)['id']!=null) {
      return jsonDecode(result.body);
    }
    else
      return null;

  }

  updateAnime(Token token, int id) async {
    print("recuperation des données...");
    Map<String, String> header = {
      'Authorization': token.token_type+' '+token.access_token
    };

    var result =  await http.get(
        'https://api.myanimelist.net/v2/anime/'+id.toString()+'?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics',
        headers: header
    );
    print("fin de la requete");


    if(jsonDecode(result.body)['id']!=null) {
      return jsonDecode(result.body);
    }
    else
      return null;

  }

}

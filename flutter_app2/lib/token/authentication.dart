import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_app2/token/token.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io' show HttpServer, sleep;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {

  static const clientId = 'fa9769a115446d73ce14fa54f2fc8210';
  var code;
  Token token;
  static Authentication _singleton;

  Authentication() {

  }

  static Authentication getSingleton(){
    //print("appel au singleton de authentication");
    if(_singleton==null) {
      _singleton = new Authentication();
    }
    return _singleton;
  }


  ///////////////////// get user autorization  //////////////////
  void authenticate() async {
    code = getRandomString(128);
    startServer();
    final url = Uri.https('myanimelist.net', '/v1/oauth2/authorize', {
      'response_type': 'code',
      'client_id': clientId,
      'code_challenge': code,
      'state': 'RequestID42',
    }).toString();
    final callbackUrlScheme = 'myapp';

    try {
      await FlutterWebAuth.authenticate(url: url, callbackUrlScheme: callbackUrlScheme);
    } on PlatformException {
    }
  }

  Future<void> startServer() async {
    final server = await HttpServer.bind('127.0.0.1', 43823);

    server.listen((req) async {
      //print(req.uri);
      if(req.uri.toString().contains("code")){
        await this.get_token(req.uri.toString());
        server.close(force: true);
      }
    });
  }


  ////////////////////  get token ///////////////////////////
  Future<void> get_token(String msg) async {
    var tab  = msg.split("?");
    var codeRetour= tab[1].split("=")[1].split("&")[0];

    Map<String, String> mapBody = {
      'client_id': clientId,
      'code': codeRetour,
      'code_verifier': code,
      'grant_type': 'authorization_code'
    };
    var result =  await http.post(
        Uri.https(
            'myanimelist.net',
            '/v1/oauth2/token'
        ),
        body: mapBody
    );



    this.token = Token.fromJson(jsonDecode(result.body));
    await saveTokenInStorage(this.token);
    print("token recupéré et sauvegardé");
    print("storage : "+(await getTokenInStorage()).token_type.toString());
    print("use : "+token.expiration_date.toString());
  }

  ///////////////////// refresh_token ////////////////////////

  Future<void> refresh_token() async {

    Map<String, String> mapBody = {
      'client_id': clientId,
      'grant_type': 'refresh_token',
      'refresh_token':this.token.refresh_token
    };

    var result =  await http.post(
        Uri.https(
            'myanimelist.net',
            '/v1/oauth2/token'
        ),
        body: mapBody
    );

    Token temp_token = Token.fromJson(jsonDecode(result.body));
    print("nouveau token");

    await saveTokenInStorage(temp_token);
    this.token = temp_token;
  }



  //////////////////////locale storage ///////////////////////
  saveTokenInStorage(Token tokenToSave) async {
    print("token sauvegarde sur le stockage local");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", json.encode(tokenToSave.toJson()));
    print("enregistrement ok");
  }

  Future<Token> getTokenInStorage() async {
    print("tentative de recuperation du token");
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('token')) {
      print("recuperation ok");
      Token tempToken = await Token.fromJson(json.decode(await prefs.getString("token")));
      print("valide jusqu'a "+tempToken.expiration_date.toString());
      //return null;
      return tempToken;
    } else {
      return null; //pas de token dans le stockage du telephone
    }
  }





  ///////////////// Tests ////////////////////////
  bool isTokenExists() {
    return token!=null;
  }

  bool isTokenExpired(){
    return token.expiration_date.isAfter(DateTime.now());
  }


  ////////////////////// generate code ////////////////////////////
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


}








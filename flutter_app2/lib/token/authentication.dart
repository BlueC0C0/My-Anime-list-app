import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_app2/token/token.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io' show HttpServer, sleep;

import 'package:flutter/material.dart';
import 'package:flutter_app2/animeList/animeUI.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  static const clientId = 'fa9769a115446d73ce14fa54f2fc8210';
  var code;
  Token token;
  bool connected = false;

  static Authentication _singleton;
  static Authentication getSingleton(){
    print("appel au singleton de authentication");
    if(_singleton==null) {
      print('initialisation du singleton');
      _singleton = new Authentication();
    }
    return _singleton;
  }

  void authenticate() async {
      connected=false;
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

  tryConnection() async {
    if(!connected){
      await getToken();
      if(token==null){
        return false;
      }
    }
    return true;
  }


  Future<void> get_token(String msg) async {
    var tab  = msg.split("?");
    var codeRetour= tab[1].split("=")[1].split("&")[0];

    Map<String, String> mapBody = {
      'client_id': clientId,
      'code': codeRetour,
      'code_verifier': code,
      'grant_type': 'authorization_code'
    };
    var result =  await http.post('https://myanimelist.net/v1/oauth2/token',
        body: mapBody);

    this.token = Token.fromJson(jsonDecode(result.body));
    print("vous etes connecté");
    saveToken();
    connected = true;
  }

  Future<void> refresh_connection() async {
    if(token==null){
      this.connected = false;
      this.authenticate();
    }
    if(this.token.dateFin.isBefore(DateTime.now()))
      refresh_token();
  }

  Future<void> refresh_token() async {

    Map<String, String> mapBody = {
      'client_id': clientId,
      'grant_type': 'refresh_token',
      'refresh_token':this.token.refresh_token
    };

    var result =  await http.post('https://myanimelist.net/v1/oauth2/token',
        body: mapBody);

    this.token = Token.fromJson(jsonDecode(result.body));
    saveToken();
    this.connected = true;
  }


  Future<void> startServer() async {
    final server = await HttpServer.bind('127.0.0.1', 43823);

    server.listen((req) async {
      //print(req.uri);
      if(req.uri.toString().contains("code")){
        await this.get_token(req.uri.toString());
        server.close(force: true);
        await this.refresh_connection();
      }
    });
  }


  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  saveToken() async {
    print("token sauvegarde sur le stockage local");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", json.encode(token.toJson()));
  }

  getToken() async {
    print("tentative de recuperation du token");
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('token')) {
      this.token = Token.fromJson(await json.decode(prefs.getString("token")));
      print("token recupere");
    }
  }

}









class PageAuthentication extends StatefulWidget {
  Function fonctionAfterAuth;

  static PageAuthentication _singleton;
  static getSingleton(Function func){
    print("appel au singleton de authentication");
    if(_singleton==null) {
      print('initialisation du singleton');
      _singleton = new PageAuthentication(func);
    }else{
      _singleton.setFunction(func);
    }
    return _singleton;
  }

  PageAuthentication(Function func){
    this.fonctionAfterAuth = func;
  }



  @override
  _PageAuthenticationState createState() => _PageAuthenticationState();

  void setFunction(Function func) {this.fonctionAfterAuth = func;}
}

class _PageAuthenticationState extends State<PageAuthentication> {
  Authentication _auth = new Authentication();

  @override
  void initState() {
    super.initState();
    print("page d'authentification");
  }




  @override
  Widget build(BuildContext context) {
    return  new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 80),
        RaisedButton(
          child: Text('Authenticate'),
          onPressed: () async {
            await Authentication.getSingleton().authenticate();
            widget.fonctionAfterAuth();},
        ),
      ],
    );

  }

  void chargerList() {

  }
}
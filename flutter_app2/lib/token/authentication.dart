import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_app2/token/loadStatus.dart';
import 'package:flutter_app2/token/token.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io' show HttpServer, sleep;

import 'RequestReturn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Authentication {
  static const clientId = 'fa9769a115446d73ce14fa54f2fc8210';
  var code;
  Token token;
  static Authentication _singleton;

  Authentication() {}

  static Authentication getSingleton() {
    //print("appel au singleton de authentication");
    if (_singleton == null) {
      _singleton = new Authentication();
    }
    return _singleton;
  }

  Future<LoadStatus> tryConnection() async {
    print("-) try to connect");

    if (!isTokenExists()) {
      RequestReturn returnStatus = await getTokenInStorage();
      if (returnStatus == RequestReturn.error) {
        print("-) need to connect");
        return LoadStatus.needAction; //need to connect in oauth2
      } else if (isTokenExpired()) {
        print("-) need to refresh the token");
        returnStatus = await refresh_token();
        if (returnStatus == RequestReturn.error) {
          return LoadStatus.loadError;
        }
      } else {
        print("-) you are connected");
        return LoadStatus.loadComplete;
      }
    }
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

    try {
      await launch(url);
    } on PlatformException {}
  }

  Future<void> startServer() async {
    final server = await HttpServer.bind('127.0.0.1', 43823);

    server.listen((req) async {
      if (req.uri.toString().contains("code")) {
        await this.get_token(req.uri.toString());

        server.close(force: true);
      }
    });
  }

  ////////////////////  get token ///////////////////////////
  Future<RequestReturn> get_token(String msg) async {
    var tab = msg.split("?");
    var codeRetour = tab[1].split("=")[1].split("&")[0];

    Map<String, String> mapBody = {
      'client_id': clientId,
      'code': codeRetour,
      'code_verifier': code,
      'grant_type': 'authorization_code'
    };
    var result = await http
        .post(Uri.https('myanimelist.net', '/v1/oauth2/token'), body: mapBody);

    this.token = Token.fromJson(jsonDecode(result.body));
    if (this.token == null) {
      return RequestReturn.error;
    }
    await saveTokenInStorage(this.token);
    return RequestReturn.success;
  }

  ///////////////////// refresh_token ////////////////////////

  Future<RequestReturn> refresh_token() async {
    Map<String, String> mapBody = {
      'client_id': clientId,
      'grant_type': 'refresh_token',
      'refresh_token': this.token.refresh_token
    };
    var result = await http
        .post(Uri.https('myanimelist.net', '/v1/oauth2/token'), body: mapBody);

    Token temp_token = Token.fromJson(jsonDecode(result.body));

    if (this.token == null) {
      return RequestReturn.error;
    }
    this.token = temp_token;
    await saveTokenInStorage(this.token);
    return RequestReturn.success;
  }

  //////////////////////locale storage ///////////////////////
  saveTokenInStorage(Token tokenToSave) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", json.encode(tokenToSave.toJson()));
  }

  Future<RequestReturn> getTokenInStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      Token tempToken =
          await Token.fromJson(json.decode(await prefs.getString("token")));
      print("valide jusqu'a " + tempToken.expiration_date.toString());
      print(DateTime.now());
      print(tempToken.expiration_date.isBefore(DateTime.now()));

      token = tempToken;

      if (isTokenExpired()) {
        print("refresh du token necessaire");
        refresh_token();
      }

      return RequestReturn.success;
    } else {
      return RequestReturn.error;
    }
  }

  ///////////////// Tests ////////////////////////
  bool isTokenExists() {
    return token != null;
  }

  bool isTokenExpired() {
    return token.expiration_date.isBefore(DateTime.now());
  }

  ////////////////////// generate code ////////////////////////////
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

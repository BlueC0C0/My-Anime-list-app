

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'authentication.dart';

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
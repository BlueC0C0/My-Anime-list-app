import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'authentication.dart';

class PageAuthentication extends StatefulWidget {
  Function fonctionAfterAuth;

  static PageAuthentication _singleton;
  static getSingleton(Function func) {
    print("appel au singleton de authentication");
    if (_singleton == null) {
      print('initialisation du singleton');
      _singleton = new PageAuthentication(func);
    } else {
      _singleton.setFunction(func);
    }
    return _singleton;
  }

  PageAuthentication(Function func) {
    this.fonctionAfterAuth = func;
  }

  @override
  _PageAuthenticationState createState() => _PageAuthenticationState();

  void setFunction(Function func) {
    this.fonctionAfterAuth = func;
  }
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
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 70,
            left: 20,
            right: 20,
          ),
          child: Text(
            "Welcome\nto\nManime !",
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w700,
              fontSize: 60,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              "Please, log in using the button below",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w700,
                fontSize: 30,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              onPressed: () async {
                await Authentication.getSingleton().authenticate();
                widget.fonctionAfterAuth();
              },
            ),
          ),
        ),
      ],
    );
  }

  void chargerList() {}
}

import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/token.dart';

import 'animeUI.dart';
import 'animeListRequests.dart';

class ViewAnimeList extends StatefulWidget {
  String page;

  ViewAnimeList(this.page);

  @override
  _ViewAnimeListState createState() => _ViewAnimeListState();
}

class _ViewAnimeListState extends State<ViewAnimeList> with AutomaticKeepAliveClientMixin<ViewAnimeList>{
  AnimeList _list = new AnimeList();
  Widget _loadingPage = new Align(
    alignment: Alignment.center,
    child: CircularProgressIndicator(),
  );
  Widget _mainPage;


  @override
  void initState() {
    super.initState();
    _mainPage = _loadingPage;
    verifierConnection();
  }

  verifierConnection() async {
    bool connected  = await Authentication.getSingleton().tryConnection();
    if(!connected){
      print("vous devez vous connecter");
      setState(() {
        _mainPage =  PageAuthentication.getSingleton(chargerPage);
      });
    } else {
      print("vous etes connecte");
      _mainPage = _loadingPage;
      chargerPage();
    }
  }



  chargerPage() async {
      List<Anime> animeList = await _list.chargerList(Authentication.getSingleton().token,widget.page);

      List<Widget> widgetList = new List<Widget>();
      for (Anime anime in animeList) {
        widgetList.add(AnimeUI(anime,false));
      }

      Widget widgetTemp = new GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 9/14,
          children: widgetList
      );
      if(this.mounted){
        setState(() {
          _mainPage = widgetTemp;
        });
      }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            widget.page,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 30,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body:_mainPage
    );

  }

  @override
  bool get wantKeepAlive => true;
}
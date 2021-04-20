import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/animeList/animeUI.dart';
import 'package:flutter_app2/animeList/animeListRequests.dart';
import 'package:flutter_app2/animeList/pageErreur.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/pageAuthentication.dart';
import 'package:flutter_app2/token/token.dart';



class PageAnimeSaison extends StatefulWidget {
  @override
  _PageAnimeSaisonState createState() => _PageAnimeSaisonState();
}


class _PageAnimeSaisonState extends State<PageAnimeSaison> with AutomaticKeepAliveClientMixin<PageAnimeSaison> {

  Widget _loadingPage = new Align(
    alignment: Alignment.center,
    child: CircularProgressIndicator(),
  );
  Widget _mainPage;



  @override
  void initState() {
    super.initState();
    chargerPage();
  }


  chargerPage() async {
    setState(() {
      _mainPage = _loadingPage;
    });

      List<Anime> animeList = await AnimeRequest.chargerSaison(Authentication.getSingleton().token);

      if(animeList==null) {
        setState(() {
          _mainPage = PageErreur(chargerPage);
        });
        return;
      }


      animeList.sort((a, b) => b.getRank().compareTo(a.getRank()));

      List<Widget> widgetList = new List<Widget>();
      for (Anime anime in animeList) {
        widgetList.add(AnimeUI(anime,false));
      }

      Widget widgetTemp = new GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 9/14,
        children: widgetList,
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
          "animes de saison",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _mainPage
    );

  }

  @override
  bool get wantKeepAlive => true;
}
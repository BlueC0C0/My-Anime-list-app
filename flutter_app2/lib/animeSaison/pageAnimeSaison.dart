import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/animeList/animeUI.dart';
import 'package:flutter_app2/animeList/animeListRequests.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/token.dart';



class PageAnimeSaison extends StatefulWidget {
  @override
  _PageAnimeSaisonState createState() => _PageAnimeSaisonState();
}


class _PageAnimeSaisonState extends State<PageAnimeSaison> with AutomaticKeepAliveClientMixin<PageAnimeSaison> {
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

      String temp = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImI2MWI2YzMzNTMyMDdiNTJiMGM1ODI1MmRiYjY5OTMwMzU3OTc3NjVkZDc1ZTc0ZGRhMmVjODA2YzgxOGQ0YjFkMjAwN2JiM2NlNjJmODk0In0.eyJhdWQiOiJmYTk3NjlhMTE1NDQ2ZDczY2UxNGZhNTRmMmZjODIxMCIsImp0aSI6ImI2MWI2YzMzNTMyMDdiNTJiMGM1ODI1MmRiYjY5OTMwMzU3OTc3NjVkZDc1ZTc0ZGRhMmVjODA2YzgxOGQ0YjFkMjAwN2JiM2NlNjJmODk0IiwiaWF0IjoxNjA3MTA0Nzk3LCJuYmYiOjE2MDcxMDQ3OTcsImV4cCI6MTYwOTc4MzE5Nywic3ViIjoiODQ4NTExMCIsInNjb3BlcyI6W119.Hsjuu99Ecp_zspz3kXdIhSkZyM5CRMQCnBEbejmR6JovRy8nvwOI2mG6auyQwWTMufXy-rHTv-2tj_NfjKeKGkBym-oO5YVKHrEw2RFmWRlsvyGT9zFricbruvhJz6HBvDBDTJ0X3gZZGtobsP48a_04xJoijv_ah9troj3t5PwY1MqV0YYZpNoDYi2e2-ep_xNIv8rYl2b5RG3P_4zL9fUaesdRD6tsYWEPLIuSG0c1ES-NkJfZz01Nm3bujJYViV0H8vgQ2exm154pg0bCDeUvgiLtSIdwJXTa1klPgivF46ocWEJLMz7BnzSey0kn1kLMKHL0l7iDbGvwSkE5tw" ;
      print("je charge la page");
      List<Anime> animeList = await _list.chargerSaison(Token("Bearer", 0, temp,""));
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
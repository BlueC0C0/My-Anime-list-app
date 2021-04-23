import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/Seasons.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/anime/listStatus.dart';
import 'package:flutter_app2/animeList/animeListRequests.dart';
import 'package:flutter_app2/animeList/animeUI.dart';
import 'package:flutter_app2/animeList/pageErreur.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/pageAuthentication.dart';
import 'package:flutter_app2/token/token.dart';

class ViewAnimeListSeason extends StatefulWidget {
  Seasons page;
  int year;

  ViewAnimeListSeason(this.page,this.year);

  _ViewAnimeListSeasonState state;


  @override
  _ViewAnimeListSeasonState createState()  {
    state = _ViewAnimeListSeasonState();
    return state;
  }

  void refreshList() {
    if(state!=null)
      state.chargerPage();
  }
}

class _ViewAnimeListSeasonState extends State<ViewAnimeListSeason>
    with AutomaticKeepAliveClientMixin<ViewAnimeListSeason> {
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

    List<Anime> animeList = await AnimeRequest.chargerSaison(
        Authentication.getSingleton().token, widget.year, widget.page);

    if (animeList == null) {
      setState(() {
        _mainPage = PageErreur(chargerPage);
      });
      return;
    }
    List<Widget> widgetList = [];
    for (Anime anime in animeList) {
      widgetList.add(AnimeUI(anime, false));
    }

    Widget widgetTemp = Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: ((MediaQuery.of(context).size.width - 10) / 3) /
              (((MediaQuery.of(context).size.width - 10) / 3 * 1.41) + 25),
          children: widgetList),
    );
    if (this.mounted) {
      setState(() {
        _mainPage = widgetTemp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _mainPage;
  }

  @override
  bool get wantKeepAlive => true;

  void refreshList() {

  }
}

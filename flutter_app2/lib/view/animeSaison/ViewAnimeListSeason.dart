import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/Seasons.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/network/animeListRequests.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/loadStatus.dart';
import 'package:flutter_app2/view/animeList/Utils.dart';
import 'package:flutter_app2/view/animeList/animeUI.dart';
import 'package:flutter_app2/view/animeList/pageErreur.dart';

class ViewAnimeListSeason extends StatefulWidget {
  Seasons page;
  int year;
  TextEditingController _textController;
  ViewAnimeListSeasonState state;

  ViewAnimeListSeason(this.page, this.year, this._textController);

  @override
  ViewAnimeListSeasonState createState() {
    state = ViewAnimeListSeasonState();
    return state;
  }

  changeYear(int newYear) {
    year = newYear;
    if (state != null) {
      state.chargerPage();
    }
  }
}

class ViewAnimeListSeasonState extends State<ViewAnimeListSeason>
    with AutomaticKeepAliveClientMixin<ViewAnimeListSeason> {
  LoadStatus _loadStatus;
  List<Anime> animeList = [];
  List<Anime> displayAnimeList = [];

  @override
  void initState() {
    super.initState();
    widget._textController.addListener(() => manageList());
    chargerPage();
  }

  manageList() {
    if (this.mounted) {
      setState(() {
        print(">" + displayAnimeList.length.toString());
        print(">" + displayAnimeList.length.toString());
        displayAnimeList = animeList.where((anime) {
          if (widget._textController.value.text.isNotEmpty) {
            List<String> list = anime.getTitles();
            for (String title in list) {
              if (title
                  .contains(widget._textController.value.text.toLowerCase())) {
                return true;
              }
            }
            return false;
          } else {
            return true;
          }
        }).toList();
        print("<" + displayAnimeList.length.toString());
      });
    }
  }

  chargerPage() async {
    setState(() {
      _loadStatus = LoadStatus.loading;
    });

    animeList = await AnimeRequest.chargerSaison(
        Authentication.getSingleton().token, widget.year, widget.page);

    if (animeList == null) {
      animeList = [];
      setState(() {
        _loadStatus = LoadStatus.loadError;
      });
      return;
    }

    if (this.mounted) {
      setState(() {
        _loadStatus = LoadStatus.loadComplete;
      });
    }

    manageList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: _loadStatus == LoadStatus.loading
          ? new Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                  color: AdaptiveTheme.of(context).theme.hintColor),
            )
          : _loadStatus == LoadStatus.loadError
              ? PageErreur(null)
              : GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: ((MediaQuery.of(context).size.width - 10) /
                          3) /
                      (((MediaQuery.of(context).size.width - 10) / 3 * 1.41) +
                          25),
                  children: List.generate(
                      displayAnimeList.length,
                      (index) =>
                          AnimeUI(displayAnimeList.elementAt(index), false))),
      padding: EdgeInsets.symmetric(horizontal: 5),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void refreshList() {}
}

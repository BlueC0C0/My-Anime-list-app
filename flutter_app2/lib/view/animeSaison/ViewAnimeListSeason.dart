import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/Seasons.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/network/animeListRequests.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/loadStatus.dart';
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
  List<AnimeUI> animeList;
  List<AnimeUI> displayAnimeList;

  @override
  void initState() {
    super.initState();
    widget._textController.addListener(() => manageList());
    chargerPage();
  }

  manageList() {
    if (this.mounted) {
      setState(() {
        displayAnimeList = animeList.where((string) {
          if (widget._textController.value.text.isNotEmpty) {
            return string.anime.title
                .toLowerCase()
                .contains(widget._textController.value.text.toLowerCase());
          } else {
            return true;
          }
        }).toList();
      });
    }
  }

  chargerPage() async {
    setState(() {
      _loadStatus = LoadStatus.loading;
    });

    List<Anime> requestList = await AnimeRequest.chargerSaison(
        Authentication.getSingleton().token, widget.year, widget.page);

    if (requestList == null) {
      setState(() {
        _loadStatus = LoadStatus.loadError;
      });
      return;
    }
    animeList = [];
    for (Anime anime in requestList) {
      animeList.add(AnimeUI(anime, false));
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
                  children: displayAnimeList),
      padding: EdgeInsets.symmetric(horizontal: 5),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void refreshList() {}
}

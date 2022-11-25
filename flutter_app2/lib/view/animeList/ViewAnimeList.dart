import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';
import 'animeUI.dart';

class ViewAnimeList extends StatefulWidget {
  ListStatus page;
  List<Anime> animeList;
  TextEditingController _textController;

  ViewAnimeList(this.page, this.animeList, this._textController);

  @override
  _ViewAnimeListState createState() => _ViewAnimeListState();
}

class _ViewAnimeListState extends State<ViewAnimeList>
    with AutomaticKeepAliveClientMixin<ViewAnimeList> {
  List<Anime> animeList;

  List<Anime> displayAnimeList = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    animeList = [];
    for (Anime anime in widget.animeList) {
      if (widget.page == ListStatus.all ||
          widget.page == anime.userStatus.status) {
        animeList.add(anime);
      }
    }
    manageList();
    widget._textController.addListener(() => manageList());
  }

  manageList() {
    if (this.mounted) {
      setState(() {
        print(displayAnimeList.length);
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(6, 2, 6, 150),
        controller: _scrollController,
        crossAxisCount: 3,
        childAspectRatio: ((MediaQuery.of(context).size.width - 10) / 3) /
            (((MediaQuery.of(context).size.width - 10) / 3 * 1.41) + 25),
        children: List.generate(displayAnimeList.length,
            (index) => AnimeUI(displayAnimeList.elementAt(index), false)),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

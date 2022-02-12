import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/token/loadStatus.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';
import 'package:flutter_app2/icons/custom_icons_icons.dart';
import 'package:flutter_app2/network/animeListRequests.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/view/animeList/pageErreur.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ViewAnimeList.dart';
import 'package:flutter/material.dart';

class PageAnimeList extends StatefulWidget {
  @override
  _PageAnimeListState state;

  _PageAnimeListState createState() {
    state = _PageAnimeListState();
    return state;
  }
}

class _PageAnimeListState extends State<PageAnimeList>
    with
        AutomaticKeepAliveClientMixin<PageAnimeList>,
        TickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;
  TextEditingController _textController = TextEditingController();

  int _selectedIndex = 0;
  List<Anime> animeList = [];
  LoadStatus _status = LoadStatus.loading;

  bool onSearch = false;

  @override
  void initState() {
    _tabController = TabController(length: _list.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
        print(_selectedIndex);
      });
    });

    chargerAnimeList();

    super.initState();
  }

  chargerAnimeList() async {
    animeList = await AnimeRequest.chargerList(
        Authentication.getSingleton().token, ListStatus.all);
    setState(() {
      if (animeList == null) {
        _status = LoadStatus.loadError;
      } else {
        _status = LoadStatus.loadComplete;
      }
    });
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static List<ListStatus> _list = <ListStatus>[
    ListStatus.all,
    ListStatus.watching,
    ListStatus.completed,
    ListStatus.paused,
    ListStatus.dropped,
    ListStatus.plan_to_watch,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // hides leading widget
        title: onSearch
            ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    autofocus: true,
                    autocorrect: false,
                    cursorWidth: 3,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      fillColor: Colors.grey.withOpacity(0.1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    setState(() {
                      _textController.clear();
                      onSearch = false;
                    });
                  },
                  child: Icon(
                    Icons.clear,
                    size: 35,
                    color: AdaptiveTheme.of(context).theme.hintColor,
                  ),
                )
              ])
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("My List",
                      style:
                          AdaptiveTheme.of(context).theme.textTheme.headline1),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Icon(
                      CustomIcons.search,
                      size: 30,
                      color: AdaptiveTheme.of(context).theme.hintColor,
                    ),
                    onTap: () {
                      setState(() {
                        _textController.clear();
                        onSearch = true;
                      });
                    },
                  )
                ],
              ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AdaptiveTheme.of(context).theme.cardColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Text(
                "all",
                style: TextStyle(
                  fontSize: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontSize,
                  fontWeight: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontWeight,
                ),
              ),
            ),
            Tab(
              child: Text(
                "watching",
                style: TextStyle(
                  fontSize: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontSize,
                  fontWeight: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontWeight,
                ),
              ),
            ),
            Tab(
              child: Text(
                "completed",
                style: TextStyle(
                  fontSize: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontSize,
                  fontWeight: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontWeight,
                ),
              ),
            ),
            Tab(
              child: Text(
                "paused",
                style: TextStyle(
                  fontSize: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontSize,
                  fontWeight: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontWeight,
                ),
              ),
            ),
            Tab(
              child: Text(
                "dropped",
                style: TextStyle(
                  fontSize: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontSize,
                  fontWeight: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontWeight,
                ),
              ),
            ),
            Tab(
              child: Text(
                "planned",
                style: TextStyle(
                  fontSize: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontSize,
                  fontWeight: AdaptiveTheme.of(context)
                      .theme
                      .textTheme
                      .headline6
                      .fontWeight,
                ),
              ),
            )
          ],
        ),
        elevation: 0,
      ),
      body: _status == LoadStatus.loading
          ? new Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                  color: AdaptiveTheme.of(context).theme.hintColor),
            )
          : _status == LoadStatus.loadError
              ? PageErreur(null)
              : TabBarView(
                  controller: _tabController,
                  dragStartBehavior: DragStartBehavior.start,
                  children: [
                    ViewAnimeList(ListStatus.all, animeList, _textController),
                    ViewAnimeList(
                        ListStatus.watching, animeList, _textController),
                    ViewAnimeList(
                        ListStatus.completed, animeList, _textController),
                    ViewAnimeList(
                        ListStatus.paused, animeList, _textController),
                    ViewAnimeList(
                        ListStatus.dropped, animeList, _textController),
                    ViewAnimeList(
                        ListStatus.plan_to_watch, animeList, _textController),
                  ],
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_app2/anime/User.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/token/loadStatus.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';
import 'package:flutter_app2/icons/custom_icons_icons.dart';
import 'package:flutter_app2/network/animeListRequests.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/view/animeList/pageErreur.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  User user = User("RomainC", "@me",
      "https://cdn.myanimelist.net/images/userimages/8485110.jpg?t=1647778200");
  List<User> friends = [];

  @override
  void initState() {
    _tabController = TabController(length: _list.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
        print(_selectedIndex);
      });
    });
    AnimeRequest.chargerFriends(Authentication.getSingleton().token)
        .then((value) {
      //friends.add(user);
      friends.add(user);
      friends.addAll(value);

      for (User user in friends) {
        print(user.displayName + " " + user.urlName + " " + user.urlImage);
      }

      print(friends);
    });

    chargerAnimeList();

    super.initState();
  }

  chargerAnimeList() async {
    print("on charge la liste pour : " + user.displayName);
    setState(() {
      _status = LoadStatus.loading;
    });

    animeList = await AnimeRequest.chargerList(
        Authentication.getSingleton().token, ListStatus.all, user.urlName);
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
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    InkWell(
                      onTap: () {
                        showPickerArray(context);
                      },
                      child: Text(
                        user.urlName == "@me" ? "My list" : "friend's List",
                        style:
                            AdaptiveTheme.of(context).theme.textTheme.headline1,
                      ),
                    ),
                  ]),
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
                        AdaptiveTheme.of(context).toggleThemeMode();
                        print("maintenant : " +
                            AdaptiveTheme.of(context).mode.name);
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
                  children: [
                    RefreshIndicator(
                        child: ViewAnimeList(
                            ListStatus.all, animeList, _textController),
                        onRefresh: () => chargerAnimeList()),
                    RefreshIndicator(
                        child: ViewAnimeList(
                            ListStatus.watching, animeList, _textController),
                        onRefresh: () => chargerAnimeList()),
                    RefreshIndicator(
                        child: ViewAnimeList(
                            ListStatus.completed, animeList, _textController),
                        onRefresh: () => chargerAnimeList()),
                    RefreshIndicator(
                        child: ViewAnimeList(
                            ListStatus.paused, animeList, _textController),
                        onRefresh: () => chargerAnimeList()),
                    RefreshIndicator(
                        child: ViewAnimeList(
                            ListStatus.dropped, animeList, _textController),
                        onRefresh: () => chargerAnimeList()),
                    RefreshIndicator(
                        child: ViewAnimeList(ListStatus.plan_to_watch,
                            animeList, _textController),
                        onRefresh: () => chargerAnimeList()),
                  ],
                ),
    );
  }

  String _currentValue;
  showPickerArray(BuildContext context) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: Text("Choose the list")),
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(6, 2, 6, 150),
              child: Column(
                children: List.generate(
                  friends.length,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        user = friends.elementAt(index);
                        chargerAnimeList();
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                  friends.elementAt(index).urlImage,
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                friends.elementAt(index).displayName,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

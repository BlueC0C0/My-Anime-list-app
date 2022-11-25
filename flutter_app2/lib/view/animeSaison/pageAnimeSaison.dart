import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/Seasons.dart';
import 'package:flutter_app2/icons/custom_icons_icons.dart';
import 'package:flutter_app2/token/loadStatus.dart';
import 'package:numberpicker/numberpicker.dart';

import 'ViewAnimeListSeason.dart';

class PageAnimeSaison extends StatefulWidget {
  @override
  _PageAnimeSaisonState createState() => _PageAnimeSaisonState();
}

class _PageAnimeSaisonState extends State<PageAnimeSaison>
    with
        AutomaticKeepAliveClientMixin<PageAnimeSaison>,
        TickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;
  TextEditingController _textController = TextEditingController();

  int _selectedIndex = 0;
  LoadStatus _status = LoadStatus.loading;
  bool onSearch = false;
  int _current_year = DateTime.now().year;

  List<ViewAnimeListSeason> _pages;
  List<Seasons> _list = [
    Seasons.WINTER,
    Seasons.SPRING,
    Seasons.SUMMER,
    Seasons.FALL
  ];

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(length: _list.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
        print(_selectedIndex);
      });
    });
    _pages = [
      ViewAnimeListSeason(Seasons.WINTER, _current_year, _textController),
      ViewAnimeListSeason(Seasons.SPRING, _current_year, _textController),
      ViewAnimeListSeason(Seasons.SUMMER, _current_year, _textController),
      ViewAnimeListSeason(Seasons.FALL, _current_year, _textController),
    ];
    super.initState();
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Text("Seasons " + _current_year.toString(),
                        style: AdaptiveTheme.of(context)
                            .theme
                            .textTheme
                            .headline1),
                    onTap: () {
                      _showYearSelectorDialog();
                    },
                  ),
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
            tabs: List<Tab>.generate(_list.length, (int index) {
              return Tab(
                child: Text(
                  _list.elementAt(index).displayName(),
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
              );
            })),
        elevation: 0,
      ),
      body: TabBarView(
        controller: _tabController,
        dragStartBehavior: DragStartBehavior.start,
        children: _pages,
      ),
    );
  }

  int _currentValue;
  void _showYearSelectorDialog() {
    _currentValue = _current_year;
    showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 350.0,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        NumberPicker(
                            value: _currentValue,
                            minValue: 2000,
                            maxValue: 2030,
                            haptics: true,
                            selectedTextStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                            textStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.3),
                                fontSize: 23,
                                fontWeight: FontWeight.w700),
                            onChanged: (value) {
                              setModalState(() {
                                _currentValue = value;
                              });
                            }),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop(_currentValue);
                            });
                          },
                          child: Text("confirmer"),
                        )
                      ],
                    ),
                  )),
            );
          });
        }).then((int value) {
      if (value != null) {
        setState(() {
          print(value);
          _current_year = value;
          refreshPage();
        });
      }
    });
  }

  void refreshPage() {
    setState(() {
      for (ViewAnimeListSeason page in _pages) {
        page.changeYear(_current_year);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}

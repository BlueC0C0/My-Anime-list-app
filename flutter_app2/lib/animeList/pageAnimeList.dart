import 'package:toggle_switch/toggle_switch.dart';

import 'ViewAnimeList.dart';
import 'package:flutter/material.dart';

import 'animeUI.dart';



class PageAnimeList extends StatefulWidget {
  @override
  _PageAnimeListState createState() => _PageAnimeListState();

  final PageController controller = PageController(
    initialPage: 0,
  );

  goToFirstPage() {
    try {
      controller.animateToPage(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } catch (e) {}
  }

}

class _PageAnimeListState extends State<PageAnimeList>  with AutomaticKeepAliveClientMixin<PageAnimeList> {


  static List<Widget> _widgetOptions = <Widget>[
    ViewAnimeList('watching'),
    ViewAnimeList('completed'),
    ViewAnimeList('on_hold'),
    ViewAnimeList('plan_to_watch')
  ];


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView(
          controller: widget.controller,
          children: _widgetOptions
      ),
    );

  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


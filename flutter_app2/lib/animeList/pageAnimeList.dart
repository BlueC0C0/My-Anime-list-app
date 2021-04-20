import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'ViewAnimeList.dart';
import 'package:flutter/material.dart';

import 'animeUI.dart';

class PageAnimeList extends StatefulWidget {
  @override
  _PageAnimeListState state;


  _PageAnimeListState createState() {
    state = _PageAnimeListState();
    return state;
  }



}

class _PageAnimeListState extends State<PageAnimeList>
    with AutomaticKeepAliveClientMixin<PageAnimeList> {

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    ViewAnimeList('all'),
    ViewAnimeList('watching'),
    ViewAnimeList('completed'),
    ViewAnimeList('on_hold'),
    ViewAnimeList('plan_to_watch')
  ];


  final PageController controller = PageController(
    initialPage: 0,
  );

  goToPage(int nb) {
    controller.animateToPage(nb, duration: Duration(milliseconds: 400),curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // hides leading widget
          title: Text(
            "My List",
            style: GoogleFonts.rubik(
                fontWeight: FontWeight.w700,
                fontSize: 40,
                color: Color.fromRGBO(217, 217, 217, 1)),
          ),
          bottom: PreferredSize(
            preferredSize: Size.square(30),
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Row(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            goToPage(0);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Text(
                            "all",
                            style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                color: 0 == _selectedIndex
                                    ? Color.fromRGBO(217, 217, 217, 1)
                                    : Color.fromRGBO(69, 69, 69, 1),
                                fontSize: 22),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            goToPage(1);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Text(
                            "watching",
                            style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                color: 1 == _selectedIndex
                                    ? Color.fromRGBO(217, 217, 217, 1)
                                    : Color.fromRGBO(69, 69, 69, 1),
                                fontSize: 22),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            goToPage(2);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Text(
                            "completed",
                            style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                color: 2 == _selectedIndex
                                    ? Color.fromRGBO(217, 217, 217, 1)
                                    : Color.fromRGBO(69, 69, 69, 1),
                                fontSize: 22),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            goToPage(3);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Text(
                            "paused",
                            style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                color: 3 == _selectedIndex
                                    ? Color.fromRGBO(217, 217, 217, 1)
                                    : Color.fromRGBO(69, 69, 69, 1),
                                fontSize: 22),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            goToPage(4);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Text(
                            "dropped",
                            style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                color: 4 == _selectedIndex
                                    ? Color.fromRGBO(217, 217, 217, 1)
                                    : Color.fromRGBO(69, 69, 69, 1),
                                fontSize: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),

          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return;
            },
            child: PageView(
              children: _widgetOptions,
              controller: controller,
              onPageChanged: (nb) {
                setState(() {
                  _selectedIndex = nb;
                });
              },
            ) //Your scrolling widget goes here(like ListView)
            ));

/*
          Row(
            children: [
              Text("all"),
              Text("all"),
              Text("all"),
              Text("all"),
              Text("all"),
            ],
          ),
 */
  }

  @override
  bool get wantKeepAlive => true;
}

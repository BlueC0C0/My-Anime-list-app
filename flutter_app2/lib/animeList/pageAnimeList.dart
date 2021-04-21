import 'package:flutter/rendering.dart';
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
    with AutomaticKeepAliveClientMixin<PageAnimeList> {
  ScrollController _scrollController;

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Padding(
        child: ViewAnimeList(''), padding: EdgeInsets.symmetric(horizontal: 5)),
    Padding(
        child: ViewAnimeList('watching'),
        padding: EdgeInsets.symmetric(horizontal: 5)),
    Padding(
        child: ViewAnimeList('completed'),
        padding: EdgeInsets.symmetric(horizontal: 5)),
    Padding(
        child: ViewAnimeList('on_hold'),
        padding: EdgeInsets.symmetric(horizontal: 5)),
    Padding(
        child: ViewAnimeList('plan_to_watch'),
        padding: EdgeInsets.symmetric(horizontal: 5)),
  ];

  static List<GlobalKey> _widgetOptionsKey = <GlobalKey>[
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];

  final PageController controller =
      PageController(initialPage: 0, viewportFraction: 1.04);

  goToPage(int nb) {
    controller.animateToPage(nb,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  goToLabel(int nb) {
    _selectedIndex = nb;
    double indexDebut = 0;
    double indexFin = 0;
    for (int i = 0; i < nb; i++) {
      indexDebut += _widgetOptionsKey.elementAt(i).currentContext.size.width;
    }
    indexFin +=
        indexDebut + _widgetOptionsKey.elementAt(nb).currentContext.size.width;

    print(_widgetOptionsKey.elementAt(nb).currentContext.size.width);

    print("//////////");
    print("offset " + _scrollController.offset.toString());
    print("indexDebut " + indexDebut.toString());
    print("indexFin " + indexFin.toString());
    print("//////////");

    if (_scrollController.offset > indexDebut) {
      print("je suis dedans 1");
      _scrollController.animateTo(indexDebut + 0.0,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }

    if (_scrollController.offset + MediaQuery.of(context).size.width <
        indexFin) {
      print("je suis dedans 2");
      _scrollController.animateTo(indexFin - MediaQuery.of(context).size.width,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                fontSize: 35,
                color: Color.fromRGBO(217, 217, 217, 1)),
          ),
          bottom: PreferredSize(
            preferredSize: Size.square(40),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: ListView(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    InkWell(
                      key: _widgetOptionsKey.elementAt(0),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        int nb = 0;
                        setState(() {
                          goToPage(nb);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(7),
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 150),
                          child: Text("all"),
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w700,
                              color: 0 == _selectedIndex
                                  ? Color.fromRGBO(217, 217, 217, 1)
                                  : Color.fromRGBO(69, 69, 69, 1),
                              fontSize: 22),
                        ),
                      ),
                    ),
                    InkWell(
                      key: _widgetOptionsKey.elementAt(1),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        int nb = 1;
                        setState(() {
                          goToPage(nb);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(7),
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 150),
                          child: Text("watching"),
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w700,
                              color: 1 == _selectedIndex
                                  ? Color.fromRGBO(217, 217, 217, 1)
                                  : Color.fromRGBO(69, 69, 69, 1),
                              fontSize: 22),
                        ),
                      ),
                    ),
                    InkWell(
                      key: _widgetOptionsKey.elementAt(2),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        int nb = 2;
                        setState(() {
                          goToPage(nb);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(7),
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 150),
                          child: Text("completed"),
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w700,
                              color: 2 == _selectedIndex
                                  ? Color.fromRGBO(217, 217, 217, 1)
                                  : Color.fromRGBO(69, 69, 69, 1),
                              fontSize: 22),
                        ),
                      ),
                    ),
                    InkWell(
                      key: _widgetOptionsKey.elementAt(3),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        int nb = 3;
                        setState(() {
                          goToPage(nb);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(7),
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 150),
                          child: Text("paused"),
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w700,
                              color: 3 == _selectedIndex
                                  ? Color.fromRGBO(217, 217, 217, 1)
                                  : Color.fromRGBO(69, 69, 69, 1),
                              fontSize: 22),
                        ),
                      ),
                    ),
                    InkWell(
                      key: _widgetOptionsKey.elementAt(4),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        int nb = 4;
                        setState(() {
                          goToPage(nb);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(7),
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 150),
                          child: Text("dropped"),
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w700,
                              color: 4 == _selectedIndex
                                  ? Color.fromRGBO(217, 217, 217, 1)
                                  : Color.fromRGBO(69, 69, 69, 1),
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ]),
            ),
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
              pageSnapping: true,
              onPageChanged: (nb) {
                setState(() {
                  goToLabel(nb);
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

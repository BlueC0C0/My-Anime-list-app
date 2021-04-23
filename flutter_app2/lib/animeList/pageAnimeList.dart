import 'package:flutter/rendering.dart';
import 'package:flutter_app2/anime/listStatus.dart';
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

  static List<GlobalKey> _widgetOptionsKey;

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

    indexDebut-=30;
    indexFin+=30;


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
    _widgetOptionsKey = [];
    for (int i = 0; i < _list.length; i++) {
      _widgetOptionsKey.add(GlobalKey());
    }
    super.initState();
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static List<ListStatus> _list = <ListStatus>[
    ListStatus.all,
    ListStatus.watching,
    ListStatus.completed,
    ListStatus.on_hold,
    ListStatus.dropped,
    ListStatus.plan_to_watch,
  ];

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
              child: ListView.builder(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: _list.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      key: _widgetOptionsKey.elementAt(index),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          goToPage(index);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(7),
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 150),
                          child: Text(_list.elementAt(index).name),
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w700,
                              color: index == _selectedIndex
                                  ? Color.fromRGBO(217, 217, 217, 1)
                                  : Color.fromRGBO(69, 69, 69, 1),
                              fontSize: 22),
                        ),
                      ),
                    );
                  }),
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
            child: PageView.builder(
                controller: controller,
                pageSnapping: true,
                itemCount: _list.length,
                onPageChanged: (nb) {
                  setState(() {
                    goToLabel(nb);
                  });
                },
                itemBuilder: (context, currentIdx) {
                  return Padding(
                    child: ViewAnimeList(_list.elementAt(currentIdx)),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                  );
                }) //Your scrolling widget goes here(like ListView)
            ));
  }

  @override
  bool get wantKeepAlive => true;
}

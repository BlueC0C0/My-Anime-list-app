import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/Seasons.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/anime/listStatus.dart';
import 'package:flutter_app2/animeList/ViewAnimeList.dart';
import 'package:flutter_app2/animeList/animeUI.dart';
import 'package:flutter_app2/animeList/animeListRequests.dart';
import 'package:flutter_app2/animeList/pageErreur.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/pageAuthentication.dart';
import 'package:flutter_app2/token/token.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';

import 'ViewAnimeListSeason.dart';



class PageAnimeSaison extends StatefulWidget {
  @override
  _PageAnimeSaisonState createState() => _PageAnimeSaisonState();
}


class _PageAnimeSaisonState extends State<PageAnimeSaison> with AutomaticKeepAliveClientMixin<PageAnimeSaison> {

  int _selectedIndex = 0;
  ScrollController _scrollController;
  static List<GlobalKey> _widgetOptionsKey;
  int _current_year = 2020;
  List<Widget> _pages = [
    Padding(
      child: ViewAnimeListSeason(Seasons.winter,2020),
      padding: EdgeInsets.symmetric(horizontal: 5),
    ),
    Padding(
      child: ViewAnimeListSeason(Seasons.spring,2020),
      padding: EdgeInsets.symmetric(horizontal: 5),
    ),
    Padding(
      child: ViewAnimeListSeason(Seasons.summer,2020),
      padding: EdgeInsets.symmetric(horizontal: 5),
    ),
    Padding(
      child: ViewAnimeListSeason(Seasons.fall,2020),
      padding: EdgeInsets.symmetric(horizontal: 5),
    ),
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

  List<Seasons> _list = Seasons.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // hides leading widget
          title: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Season",
                  style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w700,
                      fontSize: 35,
                      color: Color.fromRGBO(217, 217, 217, 1)),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text(
                    _current_year.toString(),
                    style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                        color: Color.fromRGBO(217, 217, 217, 1)),
                  ),
                  onTap: () {
                    _showYearSelectorDialog();
                  },
                )
              ],
            ),
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
            child: PageView(
              controller: controller,
              pageSnapping: true,
              children: _pages,
              onPageChanged: (nb) {
                setState(() {
                  goToLabel(nb);
                });
              },
            )
        ));
  }


  int _currentValue;
  void _showYearSelectorDialog() {
    _currentValue = _current_year;
    print("je vais afficher");
    showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  height: 350.0,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20.0),
                              topRight: const Radius.circular(20.0)
                          )
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            NumberPicker(
                                value: _currentValue,
                                minValue: 2000,
                                maxValue: 2030,
                                onChanged: (value) {
                                  setModalState(() {
                                    _currentValue = value;
                                  });
                                }
                            ),
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
                      )
                  ),
                );
              }
          );
        }
    ).then((int value) {
      if(value != null) {
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
      for(Padding widget in _pages) {
        ViewAnimeListSeason page = widget.child;
        page.year = _current_year;
        print("refresh");
        page.refreshList();
      }
    });

  }

  @override
  bool get wantKeepAlive => true;
}
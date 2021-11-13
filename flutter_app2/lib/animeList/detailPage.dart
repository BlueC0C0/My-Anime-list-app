import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/anime/listStatus.dart';
import 'package:flutter_app2/animeList/animeListRequests.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/token.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:numberpicker/numberpicker.dart';
import 'animeUI.dart';
import 'dart:math';

class PageAnimeDetail extends StatefulWidget {
  Anime anime;
  bool needLoading = false;

  PageAnimeDetail(this.anime, [this.needLoading]);

  @override
  _PageAnimeDetailState createState() => _PageAnimeDetailState();
}

class _PageAnimeDetailState extends State<PageAnimeDetail> {
  Widget recommandations;
  Widget related_animes;
  Widget details;
  Widget actions;
  Widget _mainPage;
  NetworkImage _mainPicture;
  double _pictureOffset = 0;
  ScrollController _scrollController;

  Widget _loadingPage = Align(
    alignment: Alignment.center,
    child: CircularProgressIndicator(),
  );

  _PageAnimeDetailState();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        setState(() {
          _pictureOffset = _scrollController.offset / 2;
        });
      }
      print(_pictureOffset);
    });
    recommandations = _loadingPage;
    related_animes = _loadingPage;
    _mainPage = _loadingPage;
    _mainPicture = NetworkImage(widget.anime.mainImage.medium);
    chargerPage();
  }

  Future<void> chargerPage() async {
    dynamic json = await AnimeRequest.chargerAnimeDetail(
        Authentication.getSingleton().token, widget.anime.id);
    widget.anime = Anime.fromJson(json);
    //loadRecommandations();
    //loadRelatedAnimes();
    //loadActions();
    //loadDetails();
    print(widget.anime.nsfw);
    Widget widgetTemp = Column(
      children: [
        Text(
          "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
        ),
        //title(),
        //details,
        //actions,
        //synopsis(),
        //recommandations,
        //related_animes,
        Padding(
          padding: EdgeInsets.only(top: 50),
        )
      ],
    );

    if (this.mounted) {
      setState(() {
        _mainPage = widgetTemp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 17, 17, 1),
      body: Column(
        children: [
          ClipRRect(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _mainPicture,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                child: Container(
                  color: Color.fromRGBO(10, 10, 10, 0.5),
                  padding: EdgeInsets.all(15),
                  child: Container(
                    child: Positioned(
                      top: _pictureOffset,
                      child: Image(
                        image: _mainPicture,
                        width: MediaQuery.of(context).size.width / 3,
                        height:
                            (MediaQuery.of(context).size.width / 3) * (14 / 9),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Color.fromRGBO(17, 17, 17, 1),
            child: _mainPage,
          )
        ],
      ),
    );
  }
  /*
   @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromRGBO(17, 17, 17, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _mainPicture,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                child: Container(
                  color: Color.fromRGBO(10, 10, 10, 0.5),
                  padding: EdgeInsets.all(15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      image: _mainPicture,
                      width: MediaQuery.of(context).size.width/3,
                      height: (MediaQuery.of(context).size.width/3)*(14/9),
                    ),
                  ),
                ),
              ),
            ),
            new Container(
              color: Color.fromRGBO(17, 17, 17, 1),
              child: _mainPage,
            )
          ],
        ),
      ),
    );

  }
   */

/*
  loadDetails(){
    setState(() {
      details = Container(
        color: Color.fromRGBO(17, 17, 17, 1),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.anime.status+"  -  "+widget.anime.type,
              style: TextStyle(
                  color: Colors.white30,
                  fontSize: 14
              ),
            ),
            Text(
              widget.anime.score.toString()+" ★",
              style: TextStyle(
                  color: Colors.white30,
                  fontSize: 14
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget title(){
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5),
        child: Text(
          widget.anime.title,
          style: TextStyle(
              fontSize: 28,
              color: Colors.white70
          ),
          textAlign: TextAlign.start,
        )
    );
  }

  bool _first = true;//for the animatedCrossFade of synopsis
  Widget synopsis(){
    return Column(
      children: [
        Divider(
          color: Colors.black,
          height: 20,
          thickness: 2,
          indent: 10,
          endIndent: 10,
        ),
        InkWell(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child:Text(
              "synopsis",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          onTap: () {
            _first = ! _first;
          },
        ),
        AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Container(
              margin: EdgeInsets.all(5),
              child:  Text(
                widget.anime.synopsis,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17
                ),
              ),
            ),
            crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 100),
        ),

      ],
    );
  }

  loadRecommandations(){
    List<Widget> recommandationsWidget = new List<Widget>();

    if(widget.anime.recommandations.length!=0) {
      for (int i = 0; i < widget.anime.recommandations.length; i++) {
        recommandationsWidget.add(
            AnimeUI(widget.anime.recommandations.elementAt(i), true));
      }
      setState(() {
        recommandations = Container(
          child: Column(
            children: [
              Divider(
                color: Colors.black,
                height: 20,
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "recommandations",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                height: 100 * (14 / 9),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: recommandationsWidget
                  ),
                ),
              ),
            ],
          ),
        );
      });
    } else {
      setState(() {
        recommandations = Container();
      });
    }
  }

  loadRelatedAnimes(){
    List<Widget> relatedAnimeWidget = new List<Widget>();
    print(widget.anime.related_anime.length);

    if(widget.anime.related_anime.length!=0) {
      for (int i = 0; i < widget.anime.related_anime.length; i++) {
        relatedAnimeWidget.add(
            AnimeUI(widget.anime.related_anime.elementAt(i), true));
      }
      setState(() {
        related_animes = Container(
          child: Column(
            children: [
              Divider(
                color: Colors.black,
                height: 20,
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "recommandations",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                height: 100 * (14 / 9),
                width: double.infinity,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: relatedAnimeWidget,
                    )
                ),
              ),
            ],
          ),
        );
      });


    } else {
      setState(() {
        related_animes = Container();
      });
    }

  }

  loadActions() {
    if(widget.anime.statusList.status == ListStatus.watching){
      setState(() {
        print("je reset les valeurs "+widget.anime.statusList.nb_ep_watched.toString());

        actions =  Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border:  Border.all(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "watching",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  setState(() {
                    _showDialog();
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  decoration: BoxDecoration(
                  ),
                  child: Text(
                    widget.anime.statusList.nb_ep_watched.toString()+"/"+widget.anime.nb_episodes.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      });
    } else {
      setState(() {
        actions = Container();
      });
    }

  }

  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPicker(
            minValue: 1,
            maxValue: 10,
            value: widget.anime.statusList.nb_ep_watched,
          );
        }
    ).then((value) {
      if (value != null) {
          widget.anime.changeNbEpisode(value).then((value) {
            setState(() {
                loadActions();
            });
          });
      }
    });
  }
  */
}

class DeployableMenu extends StatefulWidget {
  Widget _widget;
  String _name;
  DeployableMenu(this._widget, this._name);

  @override
  _DeployableMenuState createState() => _DeployableMenuState();
}

class _DeployableMenuState extends State<DeployableMenu> {
  bool _droppedDown;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      padding: EdgeInsets.only(left: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
      ),
      child: Column(
        //la semaine
        children: [
          Container(
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Ink(
                padding: EdgeInsets.all(7),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  children: [
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 100),
                      firstChild: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white70,
                      ),
                      secondChild: Transform.rotate(
                        angle: 90 * pi / 180,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white70,
                        ),
                      ),
                      crossFadeState: _droppedDown == true
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),
                    Text(
                      widget._name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  _droppedDown == true
                      ? _droppedDown = false
                      : _droppedDown = true;
                });
              },
            ),
          ),
          Container(
            width: double.infinity,
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 100),
              firstChild: Container(),
              secondChild: widget._widget,
              crossFadeState: _droppedDown == true
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ],
      ),
    );
  }
}

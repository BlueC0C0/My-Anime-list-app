import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/anime/listStatus.dart';
import 'package:flutter_app2/animeList/detailPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AnimeUI extends StatefulWidget {
  final Anime anime;

  AnimeUI(this.anime, this.needLoading);

  bool needLoading;

  @override
  _AnimeUIState createState() => _AnimeUIState();
}

class _AnimeUIState extends State<AnimeUI> {
  Widget _addEpisodeWidget = Container();

  Widget _addEpisodeWidgetOn = Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Colors.white70, borderRadius: BorderRadius.circular(50)),
    child: Text(
      "+1",
      style: TextStyle(fontSize: 25),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCupertinoModalBottomSheet(
          //expand: true,
          context: context,
          //bounce: true,
          builder: (context) =>
              PageAnimeDetail(widget.anime, widget.needLoading)),
      onDoubleTap: () {
        if (widget.anime.userStatus.status == ListStatus.watching) {
          setState(() {
            _addEpisodeWidget = _addEpisodeWidgetOn;
          });
          Future.delayed(Duration(milliseconds: 400)).then((value) {
            setState(() {
              _addEpisodeWidget = Container();
            });
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 3, right: 3, left: 3, top: 3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 10 / 14.10,
                child: Container(
                  child: Center(child: _addEpisodeWidget),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(
                      widget.anime.mainImage.medium,
                    ),
                    fit: BoxFit.cover,
                  )),
                ),
              ),
              SizedBox(
                height: 5,
                child: Container(color: widget.anime.userStatus.getColor()),
              ),
              SizedBox(
                width: double.infinity,
                height: 20,
                child: Container(
                  padding: EdgeInsets.all(3),
                  color: Colors.black,
                  child: Text(
                    widget.anime.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11, color: Color.fromRGBO(217, 217, 217, 1)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

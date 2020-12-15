import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/animeList/detailPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class AnimeUI extends StatefulWidget {
  final Anime anime;
  AnimeUI(this.anime,this.needLoading);

  bool needLoading;

  @override
  _AnimeUIState createState() => _AnimeUIState();
}

class _AnimeUIState extends State<AnimeUI> {

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(bottom: 3, right: 3, left: 3, top: 3),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.anime.mainImage.medium),
          fit: BoxFit.cover
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white30,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => showCupertinoModalBottomSheet(
          expand: true,
              context: context,
                bounce: true,
                builder: (context) => PageAnimeDetail(widget.anime,widget.needLoading)
            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



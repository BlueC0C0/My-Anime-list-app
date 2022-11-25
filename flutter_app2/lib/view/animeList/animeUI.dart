import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/TitleVersion.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/view/animeList/Utils.dart';
import 'package:flutter_app2/view/animeList/detailPage/detailPage.dart';

class AnimeUI extends StatelessWidget {
  final Anime anime;
  bool needLoading;

  AnimeUI(this.anime, this.needLoading);

  /*
  Widget _addEpisodeWidget = Container();

  Widget _addEpisodeWidgetOn = Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Colors.white70, borderRadius: BorderRadius.circular(50)),
    child: Text(
      "+1",
      style: TextStyle(fontSize: 25),
    ),
  );*/

  @override
  Widget build(BuildContext context) {
    //print(widget.anime.id.toString() + " " + widget.anime.title);
    return InkWell(
      onTap: () => Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (ctxt) => new PageAnimeDetail(anime, true)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, right: 4, left: 4, top: 4),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: anime.mainImage.medium,
                    cacheKey: anime.id.toString(),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 2),
              child: Text(
                anime.getTitle(Utils.getSingleton().getTitleVersion()),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AdaptiveTheme.of(context).theme.textTheme.headline5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    //print(widget.anime.id.toString() + " " + widget.anime.title);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (ctxt) => new PageAnimeDetail(widget.anime)),
      ),
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
        margin: EdgeInsets.only(bottom: 8, right: 4, left: 4, top: 4),
        child: Container(
          child: Column(
            //color: widget.anime.userStatus.getColor(),
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      widget.anime.mainImage.medium,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 20,
                child: Container(
                  padding: EdgeInsets.all(3),
                  child: Text(
                    widget.anime.title,
                    overflow: TextOverflow.ellipsis,
                    style: AdaptiveTheme.of(context).theme.textTheme.headline5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }*/
}

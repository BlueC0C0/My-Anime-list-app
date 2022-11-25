import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';
import 'package:flutter_app2/token/loadStatus.dart';
import 'package:flutter_app2/view/animeList/detailPage/CustomNumberPicker.dart';
import 'package:flutter_app2/view/animeList/detailPage/StatusListIndicator.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAnimeBottomPage extends StatefulWidget {
  Anime _anime;

  EditAnimeBottomPage(this._anime);

  @override
  _EditAnimeBottomPageState createState() => _EditAnimeBottomPageState();
}

class _EditAnimeBottomPageState extends State<EditAnimeBottomPage> {
  ListStatus currentStatus;
  int currentNbEpisodes = 0;
  int currentScore = 0;
  LoadStatus modificationLoadStatus = LoadStatus.loadComplete;

  @override
  void initState() {
    currentStatus = widget._anime.userStatus.status;
    if (currentStatus == ListStatus.none) {
      currentStatus = ListStatus.watching;
    }
    currentNbEpisodes = widget._anime.userStatus.nb_ep_watched;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: ContinuousRectangleBorder(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            size: 40,
          ),
        ),
        title: Text(
          "Edit anime's datas",
          style: GoogleFonts.rubik(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusListIndicator(ListStatus.watching, currentStatus,
                          () {
                        setState(() {
                          currentStatus = ListStatus.watching;
                        });
                      }),
                      SizedBox(width: 5),
                      StatusListIndicator(ListStatus.completed, currentStatus,
                          () {
                        setState(() {
                          currentStatus = ListStatus.completed;
                        });
                      }),
                      SizedBox(width: 5),
                      StatusListIndicator(
                          ListStatus.plan_to_watch, currentStatus, () {
                        setState(() {
                          currentStatus = ListStatus.plan_to_watch;
                        });
                      }),
                      SizedBox(width: 5),
                      StatusListIndicator(ListStatus.paused, currentStatus, () {
                        setState(() {
                          currentStatus = ListStatus.paused;
                        });
                      }),
                      SizedBox(width: 5),
                      StatusListIndicator(ListStatus.dropped, currentStatus,
                          () {
                        setState(() {
                          currentStatus = ListStatus.dropped;
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Number of episodes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  CustomNumberPicker(1, widget._anime.numberOfEpisodes,
                      widget._anime.userStatus.nb_ep_watched, (newValue) {
                    setState(() {
                      currentNbEpisodes = newValue;
                    });
                  }),
                  Text(
                    "Rating",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  CustomNumberPicker(0, 10, widget._anime.userStatus.score,
                      (newValue) {
                    setState(() {
                      currentScore = newValue;
                    });
                  }),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: InkWell(
              onTap: () {
                setState(() {
                  modificationLoadStatus = LoadStatus.loading;
                });

                Map<String, String> datas = {};
                datas.addAll(widget._anime.changeListStatus(currentStatus));
                datas.addAll(widget._anime.changeNbEpisode(currentNbEpisodes));
                datas.addAll(widget._anime.changeScore(currentScore));
                widget._anime.updateAnimeDatas(datas).then((value) {
                  setState(() {
                    widget._anime.userStatus.status = currentStatus;
                    widget._anime.userStatus.score = currentScore;
                    widget._anime.userStatus.nb_ep_watched = currentNbEpisodes;
                    modificationLoadStatus = LoadStatus.loadComplete;
                    Navigator.of(context).pop();
                  });
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AdaptiveTheme.of(context)
                      .theme
                      .bottomNavigationBarTheme
                      .backgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: modificationLoadStatus == LoadStatus.loadComplete
                    ? Text(
                        "Sauvegarder",
                        style: GoogleFonts.rubik(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

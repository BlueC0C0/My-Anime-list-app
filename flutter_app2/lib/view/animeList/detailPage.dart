import 'dart:html';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';
import 'package:flutter_app2/network/animeListRequests.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/loadStatus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Utils.dart';
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
  Widget body = Container();

  bool synopsisIsExpanded = false;
  LoadStatus onloadPageStatus = LoadStatus.loadComplete;

  _PageAnimeDetailState();

  @override
  void initState() {
    super.initState();
    if (widget.needLoading) {
      setState(() {
        onloadPageStatus = LoadStatus.loading;
      });
      AnimeRequest.chargerAnimeDetail(
              Authentication.getSingleton().token, widget.anime.id)
          .then((json) => setState(() {
                onloadPageStatus = LoadStatus.loadComplete;
                widget.anime = Anime.fromJson(json);
              }));
    }

    AdaptiveTheme.of(context).modeChangeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.mode_edit),
          backgroundColor: AdaptiveTheme.of(context)
              .theme
              .bottomNavigationBarTheme
              .backgroundColor,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => EditAnimeBottomPage(widget.anime),
            );
          },
        ),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              actions: [],
              backgroundColor: Colors.transparent,
              expandedHeight: MediaQuery.of(context).size.height / 2,
              stretch: true,
              flexibleSpace: Stack(
                children: [
                  Positioned(
                    bottom: 1,
                    right: 0,
                    left: 0,
                    top: 0,
                    child: FlexibleSpaceBar(
                      stretchModes: [
                        StretchMode.zoomBackground,
                      ],
                      background: Image.network(
                        widget.anime.mainImage.large,
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  FlexibleSpaceBar(
                    titlePadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    title: Text(
                      widget.anime.title,
                      textAlign: TextAlign.center,
                      style:
                          AdaptiveTheme.of(context).theme.textTheme.headline2,
                    ),
                    stretchModes: [
                      StretchMode.zoomBackground,
                    ],
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 0.7, 0.9, 1],
                          colors: [
                            AdaptiveTheme.of(context)
                                .theme
                                .backgroundColor
                                .withOpacity(0),
                            AdaptiveTheme.of(context)
                                .theme
                                .backgroundColor
                                .withOpacity(0.4),
                            AdaptiveTheme.of(context)
                                .theme
                                .backgroundColor
                                .withOpacity(0.9),
                            AdaptiveTheme.of(context)
                                .theme
                                .backgroundColor
                                .withOpacity(1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: onloadPageStatus == LoadStatus.loading
                    ? Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            color: AdaptiveTheme.of(context)
                                .theme
                                .bottomNavigationBarTheme
                                .backgroundColor,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            height: 60,
                            child: widget.anime.userStatus.status ==
                                    ListStatus.none
                                ? addButton()
                                : toolsBar(),
                          ),
                          synopsis(),
                          infos(),
                          SizedBox(height: 20),
                          recommendations(),
                          SizedBox(height: 50),
                        ],
                      ),
              ),
            ),
          ],
        ));
  }

  static List<ListStatus> _UserStatusList = <ListStatus>[
    ListStatus.watching,
    ListStatus.completed,
    ListStatus.paused,
    ListStatus.dropped,
    ListStatus.plan_to_watch,
  ];

  LoadStatus addLoadStatus = LoadStatus.noAction;

  Widget addButton() {
    return Center(
      child: addLoadStatus == LoadStatus.loading
          ? CircularProgressIndicator(
              color: AdaptiveTheme.of(context)
                  .theme
                  .bottomNavigationBarTheme
                  .backgroundColor,
            )
          : InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => ChangeStatusList(),
                ).then((listStatus) {
                  if (listStatus != null) {
                    setState(() {
                      addLoadStatus = LoadStatus.loading;
                    });
                    Map<String, String> datas = {};
                    datas.addAll(widget.anime.changeListStatus(listStatus));
                    widget.anime.updateAnimeDatas(datas).then((value) {
                      setState(() {
                        widget.anime.userStatus.status = listStatus;
                        addLoadStatus = LoadStatus.noAction;
                      });
                    });
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: AdaptiveTheme.of(context)
                      .theme
                      .bottomNavigationBarTheme
                      .backgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "Add to List",
                  style: TextStyle(
                      color: AdaptiveTheme.of(context).theme.backgroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
    );
  }

  Widget userStatusIndicator(ListStatus listStatus) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 110,
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
          color: Utils.getSingleton().getStatusBackgroundColor(listStatus),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          listStatus.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Utils.getSingleton().getStatusTexteColor(listStatus),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget toolsBar() {
    //print(widget.anime.userStatus.status);
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          if (widget.anime.userStatus != null &&
              widget.anime.userStatus.status != null &&
              widget.anime.userStatus.status != ListStatus.none)
            userStatusIndicator(widget.anime.userStatus.status),
          SizedBox(width: 15),
          if (widget.anime.userStatus != null &&
              widget.anime.userStatus.score != 0)
            rank(),
          SizedBox(width: 15),
        ],
      ),
    );
  }

  Widget rank() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 33, 55, 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        widget.anime.userStatus.score.toString() + " ★",
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget synopsis() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5, bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Synopsis",
              style: AdaptiveTheme.of(context).theme.textTheme.headline3,
            ),
          ),
        ),
        ConstrainedBox(
          constraints: synopsisIsExpanded
              ? new BoxConstraints(maxHeight: double.infinity)
              : new BoxConstraints(maxHeight: 100.0),
          child: Text(
            widget.anime.synopsis,
            softWrap: true,
            overflow: TextOverflow.fade,
            style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,
          ),
        ),
        Center(
            child: InkWell(
          onTap: () {
            setState(() {
              print(synopsisIsExpanded);
              synopsisIsExpanded = !synopsisIsExpanded;
            });
          },
          child: Icon(
            synopsisIsExpanded
                ? Icons.expand_less_rounded
                : Icons.expand_more_rounded,
            color: AdaptiveTheme.of(context).theme.hintColor,
            size: 50,
          ),
        ))
      ],
    );
  }

  Widget infos() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5, bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Informations",
              style: AdaptiveTheme.of(context).theme.textTheme.headline3,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              infosElmt(title: "Type", data: widget.anime.mediaType.name),
              infosElmt(title: "", data: widget.anime.mean.toString()),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              infosElmt(title: "Status", data: widget.anime.airingStatus.name),
              infosElmt(
                  title: "Saison",
                  data: widget.anime.airingSeason.season.name +
                      " " +
                      widget.anime.airingSeason.annee.toString())
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              infosElmt(title: "Start", data: widget.anime.formatedStartDate()),
              infosElmt(title: "End", data: widget.anime.formatedEndDate()),
            ],
          ),
        ),
      ],
    );
  }

  Widget infosElmt({String title, String data}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: AdaptiveTheme.of(context).theme.textTheme.subtitle1,
          ),
          SizedBox(height: 3),
          Text(
            data,
            style: AdaptiveTheme.of(context).theme.textTheme.subtitle2,
          )
        ],
      ),
    );
  }

  Widget recommendations() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5, bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Recommendations",
              style: AdaptiveTheme.of(context).theme.textTheme.headline3,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.anime.recommendations.length,
            itemBuilder: (context, index) {
              return Container(
                height: 200,
                width: 130,
                padding: EdgeInsets.symmetric(horizontal: 1),
                child: AnimeUI(
                    widget.anime.recommendations.elementAt(index), false),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChangeStatusList extends StatelessWidget {
  ChangeStatusList();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AdaptiveTheme.of(context).theme.appBarTheme.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            userStatusIndicator(context, ListStatus.watching),
            userStatusIndicator(context, ListStatus.completed),
            userStatusIndicator(context, ListStatus.dropped),
            userStatusIndicator(context, ListStatus.paused),
            userStatusIndicator(context, ListStatus.plan_to_watch)
          ],
        ),
      ),
    );
  }

  Widget userStatusIndicator(BuildContext context, ListStatus listStatus) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(listStatus);
      },
      child: Container(
        width: 200,
        padding: EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: Utils.getSingleton().getStatusBackgroundColor(listStatus),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          listStatus.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            color: Utils.getSingleton().getStatusTexteColor(listStatus),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class EditAnimeBottomPage extends StatefulWidget {
  Anime _anime;

  EditAnimeBottomPage(this._anime);

  @override
  _EditAnimeBottomPageState createState() => _EditAnimeBottomPageState();
}

class _EditAnimeBottomPageState extends State<EditAnimeBottomPage> {
  ListStatus currentStatus;

  @override
  void initState() {
    currentStatus = widget._anime.userStatus.status;
    if (currentStatus == ListStatus.none) {
      currentStatus = ListStatus.watching;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Scaffold(
        appBar: AppBar(
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
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      StatusListIndicator(ListStatus.watching, currentStatus,
                          () {
                        setState(() {
                          currentStatus = ListStatus.watching;
                        });
                      }),
                      SizedBox(width: 15),
                      StatusListIndicator(ListStatus.completed, currentStatus,
                          () {
                        setState(() {
                          currentStatus = ListStatus.completed;
                        });
                      }),
                      SizedBox(width: 15),
                      StatusListIndicator(
                          ListStatus.plan_to_watch, currentStatus, () {
                        setState(() {
                          currentStatus = ListStatus.plan_to_watch;
                        });
                      }),
                      SizedBox(width: 15),
                      StatusListIndicator(ListStatus.paused, currentStatus, () {
                        setState(() {
                          currentStatus = ListStatus.paused;
                        });
                      }),
                      SizedBox(width: 15),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Score",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: AdaptiveTheme.of(context)
                        .theme
                        .bottomNavigationBarTheme
                        .backgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "Sauvegarder",
                    style: GoogleFonts.rubik(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusListIndicator extends StatefulWidget {
  ListStatus _listStatus;
  ListStatus _currentStatus;
  Function _ontap;

  StatusListIndicator(this._listStatus, this._currentStatus, this._ontap);

  @override
  _StatusListIndicatorState createState() => _StatusListIndicatorState();
}

class _StatusListIndicatorState extends State<StatusListIndicator> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget._ontap();
      },
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: widget._currentStatus == widget._listStatus
              ? Utils.getSingleton()
                  .getStatusBackgroundColor(widget._listStatus)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(
              Utils.getSingleton().getStatusIcon(widget._listStatus),
              color: widget._currentStatus == widget._listStatus
                  ? Utils.getSingleton().getStatusTexteColor(widget._listStatus)
                  : AdaptiveTheme.of(context).theme.textTheme.headline1.color,
              size: 35,
            ),
            AnimatedContainer(
                padding: EdgeInsets.only(left: 30),
                duration: Duration(milliseconds: 100),
                child: Text(
                  widget._listStatus.name,
                  overflow: TextOverflow.ellipsis,
                ),
                width: widget._currentStatus == widget._listStatus
                    ? MediaQuery.of(context).size.width - 34 * 4
                    : 0),
          ],
        ),
      ),
    );
  }
}

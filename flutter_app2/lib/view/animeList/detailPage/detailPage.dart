import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/TitleVersion.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';
import 'package:flutter_app2/network/animeListRequests.dart';
import 'package:flutter_app2/token/authentication.dart';
import 'package:flutter_app2/token/loadStatus.dart';
import 'package:flutter_app2/view/animeList/Utils.dart';
import 'package:flutter_app2/view/animeList/VideoUI.dart';
import 'package:flutter_app2/view/animeList/animeUI.dart';
import 'package:flutter_app2/view/animeList/detailPage/ChangeStatusList.dart';
import 'package:flutter_app2/view/animeList/detailPage/EditAnimeBottomPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PageAnimeDetail extends StatefulWidget {
  Anime anime;
  bool needLoading = false;

  PageAnimeDetail(this.anime, [this.needLoading]);

  @override
  _PageAnimeDetailState createState() => _PageAnimeDetailState();
}

class _PageAnimeDetailState extends State<PageAnimeDetail> {
  Widget body = Container();
  double paddingBetweenElements = 30;
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
        backgroundColor: AdaptiveTheme.of(context).theme.backgroundColor,
        floatingActionButton: FloatingActionButton(
          child: Icon(widget.anime.userStatus.status == ListStatus.none
              ? Icons.add
              : Icons.mode_edit),
          backgroundColor: AdaptiveTheme.of(context)
              .theme
              .bottomNavigationBarTheme
              .backgroundColor,
          onPressed: () {
            if (widget.anime.userStatus.status == ListStatus.none) {
              Map<String, String> datas = {};
              datas.addAll(
                  widget.anime.changeListStatus(ListStatus.plan_to_watch));
              widget.anime.updateAnimeDatas(datas).then((value) {
                setState(() {
                  widget.anime.userStatus.status = ListStatus.plan_to_watch;
                });
              });
            } else {
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => EditAnimeBottomPage(widget.anime),
              ).then((value) {
                setState(() {});
              });
            }
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
                      child: PageView.builder(
                        itemBuilder: (context, index) {
                          return FlexibleSpaceBar(
                            stretchModes: [
                              StretchMode.zoomBackground,
                            ],
                            background: Image.network(
                              widget.anime.getImages().elementAt(index).large,
                              alignment: Alignment.topCenter,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        itemCount: widget.anime.getImages().length,
                      )),
                  IgnorePointer(
                    child: FlexibleSpaceBar(
                      titlePadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      title: Text(
                        widget.anime
                            .getTitle(Utils.getSingleton().getTitleVersion()),
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
                                  .withOpacity(0.4),
                              AdaptiveTheme.of(context)
                                  .theme
                                  .backgroundColor
                                  .withOpacity(0.7),
                              AdaptiveTheme.of(context)
                                  .theme
                                  .backgroundColor
                                  .withOpacity(0.95),
                              AdaptiveTheme.of(context)
                                  .theme
                                  .backgroundColor
                                  .withOpacity(1),
                            ],
                          ),
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
                            child: toolsBar(),
                          ),
                          synopsis(),
                          SizedBox(height: paddingBetweenElements),
                          infos(),
                          SizedBox(height: paddingBetweenElements),
                          titles(),
                          SizedBox(height: paddingBetweenElements),
                          recommendations(),
                          SizedBox(height: paddingBetweenElements),
                          //teasers(),
                          SizedBox(height: 30),
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
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: userStatusIndicator(widget.anime.userStatus.status),
            ),
          if (widget.anime.userStatus.status == ListStatus.watching ||
              widget.anime.userStatus.status == ListStatus.paused ||
              widget.anime.userStatus.status == ListStatus.dropped)
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: nbEpisodes(),
            ),
          if (widget.anime.userStatus != null &&
              widget.anime.userStatus.score != 0)
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: rank(),
            ),
        ],
      ),
    );
  }

  Widget rank() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 33, 55, 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        widget.anime.userStatus.score.toString() + " ★",
        style: TextStyle(
          fontSize: 15,
          color: Color.fromARGB(255, 78, 86, 148),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget nbEpisodes() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 33, 55, 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        widget.anime.userStatus.nb_ep_watched.toString() +
            " / " +
            widget.anime.numberOfEpisodes.toString() +
            "  eps",
        style: TextStyle(
          fontSize: 15,
          color: Color.fromARGB(255, 78, 86, 148),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  final keys = GlobalKey();

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
        Text(
          widget.anime.synopsis,
          softWrap: true,
          style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,
          textAlign: TextAlign.justify,
          maxLines: synopsisIsExpanded ? 200 : 6,
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
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              infosElmt(title: "Type", data: widget.anime.mediaType.name),
              infosElmt(
                  title: "Average rating", data: widget.anime.mean.toString()),
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
              infosElmt(
                  title: "Saison",
                  data: widget.anime.airingSeason.season.displayName() +
                      " " +
                      widget.anime.airingSeason.annee.toString()),
              infosElmt(
                  title: "Status",
                  data: widget.anime.airingStatus.displayName()),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              infosElmt(
                  title: "Start's date",
                  data: widget.anime.formatedStartDate()),
              infosElmt(
                  title: "End's date", data: widget.anime.formatedEndDate()),
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
    return widget.anime.recommendations.length == 0
        ? SizedBox.shrink()
        : Column(
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

  Widget teasers() {
    return widget.anime.videos.length == 0
        ? SizedBox.shrink()
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Videos",
                    style: AdaptiveTheme.of(context).theme.textTheme.headline3,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: (MediaQuery.of(context).size.width) * 9 / 21,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.anime.videos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(
                          bottom: 8, right: 4, left: 4, top: 4),
                      width: (MediaQuery.of(context).size.width * 0.7),
                      child: VideoUI(widget.anime.videos.elementAt(index)),
                    );
                  },
                ),
              ),
            ],
          );
  }

  Widget titles() {
    return widget.anime.getTitles().length == 1
        ? SizedBox.shrink()
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Alternative titles",
                    style: AdaptiveTheme.of(context).theme.textTheme.headline3,
                  ),
                ),
              ),
              Column(
                children: [
                  langageTile("Original", [widget.anime.title]),
                  if (widget.anime.hasVersion(TitleVersion.SYNONYMS))
                    langageTile("Synonyms", widget.anime.synonyms),
                  if (widget.anime.hasVersion(TitleVersion.ENGLISH))
                    langageTile(
                        "English", [widget.anime.alternativeTitles["en"]]),
                  if (widget.anime.hasVersion(TitleVersion.JAPANESE))
                    langageTile(
                        "Japanese", [widget.anime.alternativeTitles["ja"]]),
                ],
              ),
            ],
          );
  }

  Widget langageTile(String langage, List<String> titles) {
    List<Widget> titlesWidget = [];
    bool moreThanOne = false;
    for (String title in titles) {
      if (moreThanOne) {
        titlesWidget.add(SizedBox(
          height: 5,
        ));
      }
      titlesWidget.add(
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      );
      moreThanOne = true;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            langage,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              children: titlesWidget,
            ),
          ),
        ],
      ),
    );
  }
}

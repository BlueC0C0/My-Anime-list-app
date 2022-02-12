import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/token/loadStatus.dart';
import 'package:flutter_app2/view/animeList/pageErreur.dart';
import 'package:flutter_app2/view/animeNews/news.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PageNews extends StatefulWidget {
  @override
  _PageNewsState createState() => _PageNewsState();
}

class _PageNewsState extends State<PageNews>
    with AutomaticKeepAliveClientMixin<PageNews>, TickerProviderStateMixin {
  LoadStatus _status = LoadStatus.loading;
  List<News> news;

  @override
  void initState() {
    super.initState();
    refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // hides leading widget
          title: Text("News",
              style: AdaptiveTheme.of(context).theme.textTheme.headline1),
          elevation: 0,
        ),
        body: _status == LoadStatus.loading
            ? new Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                    color: AdaptiveTheme.of(context).theme.hintColor),
              )
            : _status == LoadStatus.loadError
                ? PageErreur(null)
                : ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => launch(news.elementAt(index).link),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                width: double.infinity,
                                child: Text(
                                  news.elementAt(index).title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 100,
                                      child: Text(
                                        news.elementAt(index).description,
                                        textAlign: TextAlign.justify,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    height: 80,
                                    margin: EdgeInsets.all(10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            news.elementAt(index).imageURL,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }));
  }

  void refreshPage() {
    setState(() {
      _status = LoadStatus.loading;
      http.get(Uri.https("myanimelist.net", "/rss/news.xml")).then((value) {
        news = News.fromXmlPage(value.body);

        _status = LoadStatus.loadComplete;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}

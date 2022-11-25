import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/token/loadStatus.dart';
import 'package:flutter_app2/view/animeList/pageErreur.dart';
import 'package:flutter_app2/view/animeNews/news.dart';
import 'package:flutter_app2/view/pageSettings/SettingsContainer.dart';
import 'package:flutter_app2/view/pageSettings/SettingsRow.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PageSettings extends StatefulWidget {
  @override
  _PageSettingsState createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings>
    with AutomaticKeepAliveClientMixin<PageSettings>, TickerProviderStateMixin {
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
        title: Text("Settings",
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
              : ListView(
                  children: [
                    SettingsContainer(title: "General", children: [
                      SettingsRow(
                          name: "theme", value: "sombre", onclick: () {}),
                      SettingsRow(
                          name: "theme", value: "sombre", onclick: () {}),
                      SettingsRow(
                          name: "theme", value: "sombre", onclick: () {})
                    ]),
                    SettingsContainer(title: "General", children: [
                      SettingsRow(
                          name: "theme", value: "sombre", onclick: () {}),
                      SettingsRow(
                          name: "theme", value: "sombre", onclick: () {}),
                      SettingsRow(
                          name: "theme", value: "sombre", onclick: () {})
                    ]),
                    SettingsContainer(title: "General", children: [
                      SettingsRow(
                          name: "theme", value: "sombre", onclick: () {}),
                      SettingsRow(
                          name: "theme", value: "sombre", onclick: () {}),
                      SettingsRow(
                          name: "theme", value: "sombre", onclick: () {})
                    ]),
                  ],
                ),
    );
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

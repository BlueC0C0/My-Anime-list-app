import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/anime.dart';
import 'package:flutter_app2/animeList/detailPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class PageErreur extends StatefulWidget {
  final Function func;
  PageErreur(this.func);

  bool needLoading;

  @override
  _PageErreurState createState() => _PageErreurState();
}

class _PageErreurState extends State<PageErreur> {


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        widget.func();
      },
      child: Center(
        child: Text("erreur de chargement"),
      ),
    );
  }
}



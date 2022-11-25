import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: () {
        if (widget.func != null) {
          widget.func();
        }
      },
      child: Center(
        child: Text("erreur de chargement"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/TitleVersion.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';

class Utils {
  static Utils _singleton;

  Utils();

  static Utils getSingleton() {
    if (_singleton == null) {
      _singleton = new Utils();
    }
    return _singleton;
  }

  Color getStatusBackgroundColor(ListStatus subStatus) {
    if (subStatus == ListStatus.watching) {
      return Color.fromRGBO(19, 66, 20, 1);
    } else if (subStatus == ListStatus.completed) {
      return Color.fromRGBO(21, 56, 113, 1);
    } else if (subStatus == ListStatus.paused) {
      return Color.fromRGBO(127, 110, 24, 1);
    } else if (subStatus == ListStatus.dropped) {
      return Color.fromRGBO(67, 19, 20, 1);
    } else if (subStatus == ListStatus.plan_to_watch) {
      return Color.fromRGBO(80, 0, 71, 1);
    } else {
      return Color.fromARGB(255, 27, 27, 27); //none
    }
  }

  Color getStatusTexteColor(ListStatus subStatus) {
    if (subStatus == ListStatus.watching) {
      return Color.fromRGBO(36, 141, 65, 1);
    } else if (subStatus == ListStatus.completed) {
      return Color.fromRGBO(62, 110, 165, 1);
    } else if (subStatus == ListStatus.paused) {
      return Color.fromRGBO(170, 170, 47, 1);
    } else if (subStatus == ListStatus.dropped) {
      return Color.fromRGBO(141, 42, 38, 1);
    } else if (subStatus == ListStatus.plan_to_watch) {
      return Color.fromRGBO(146, 48, 172, 1); //planned
    } else {
      return Color.fromARGB(255, 34, 32, 41); //none
    }
  }

  IconData getStatusIcon(ListStatus subStatus) {
    if (subStatus == ListStatus.watching) {
      return Icons.play_arrow;
    } else if (subStatus == ListStatus.completed) {
      return Icons.check;
    } else if (subStatus == ListStatus.paused) {
      return Icons.pause;
    } else if (subStatus == ListStatus.dropped) {
      return Icons.block;
    } else {
      return Icons.access_time_rounded; //planned
    }
  }

  TitleVersion getTitleVersion() {
    return TitleVersion.ENGLISH;
  }
}

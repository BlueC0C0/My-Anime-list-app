import 'dart:ui';

enum Seasons{
  winter,
  spring,
  summer,
  fall,
  none
}

extension SeasonsExtension on Seasons {

  String get name {
    switch(this) {
      case Seasons.winter:
        return "winter";
      case Seasons.spring:
        return "spring";
      case Seasons.summer:
        return "summer";
      case Seasons.fall:
        return "fall";
      case Seasons.none:
        return "unknow";
    }
  }
}


class SeasonsUtil {
  static Seasons getFromFormatedString(String ch) {
    switch (ch) {
      case "fall":
        return Seasons.fall;
      case "summer":
        return Seasons.summer;
      case "spring":
        return Seasons.spring;
      case "winter":
        return Seasons.winter;
      default:
        return Seasons.none;
    }
  }
}
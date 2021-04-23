import 'dart:ui';

enum Seasons{
  winter,
  spring,
  summer,
  fall,
}

extension ListStatusExtension on Seasons {

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
    }
  }
}
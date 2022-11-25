import 'Seasons.dart';

class Season {
  Seasons season;
  int annee;

  Season(this.annee, this.season);

  factory Season.fromJson(dynamic json) {
    if (json != null)
      return Season(
          json['year'] as int, Seasons.getFromFormatedString(json['season']));
    else
      return Season(0, Seasons.NONE);
  }

  @override
  String toString() {
    return '{ ${this.annee}, ${this.season}}';
  }
}

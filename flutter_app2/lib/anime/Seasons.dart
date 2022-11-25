import 'dart:ui';

class Seasons {
  final _value;
  const Seasons._internal(this._value);
  toString() => 'Enum.$_value';

  static const WINTER = const Seasons._internal('winter');
  static const SPRING = const Seasons._internal('spring');
  static const SUMMER = const Seasons._internal('summer');
  static const FALL = const Seasons._internal('fall');
  static const NONE = const Seasons._internal('none');

  static Seasons getFromFormatedString(String ch) {
    switch (ch) {
      case "fall":
        return Seasons.FALL;
      case "summer":
        return Seasons.SUMMER;
      case "spring":
        return Seasons.SPRING;
      case "winter":
        return Seasons.WINTER;
      default:
        return Seasons.NONE;
    }
  }

  String displayName() {
    print(this._value);
    if (this._value == Seasons.WINTER._value) {
      return "winter";
    } else if (this._value == Seasons.SPRING._value) {
      return "spring";
    } else if (this._value == Seasons.SUMMER._value) {
      return "summer";
    } else if (this._value == Seasons.FALL._value) {
      return "fall";
    } else {
      return "unknown";
    }
  }
}

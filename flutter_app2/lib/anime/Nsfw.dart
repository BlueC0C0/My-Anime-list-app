enum Nsfw{
  white,
  gray,
  black,
  none
}

class NsfwUtil {
  static Nsfw getFromFormatedString(String ch) {
    switch (ch) {
      case "white":
        return Nsfw.white;
      case "gray":
        return Nsfw.gray;
      case "black":
        return Nsfw.black;
      default:
        return Nsfw.none;
    }
  }
}
enum MediaType { unknown, tv, ova, movie, special, ona, music }

class MediaTypeUtil {
  static MediaType getFromFormatedString(String ch) {
    switch (ch) {
      case "unknown":
        return MediaType.unknown;
      case "tv":
        return MediaType.tv;
      case "ova":
        return MediaType.ova;
      case "movie":
        return MediaType.movie;
      case "special":
        return MediaType.special;
      case "ona":
        return MediaType.ona;
      case "music":
        return MediaType.music;
    }
  }
}

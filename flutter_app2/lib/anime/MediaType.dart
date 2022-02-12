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

extension MediaTypeExtension on MediaType {
  String get name {
    switch (this) {
      case MediaType.unknown:
        return "unknown";
      case MediaType.tv:
        return "tv";
      case MediaType.special:
        return "special";
      case MediaType.movie:
        return "movie";
      case MediaType.music:
        return "music";
      case MediaType.ona:
        return "ona";
      case MediaType.ova:
        return "ova";
    }
  }
}

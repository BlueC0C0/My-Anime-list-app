enum AiringStatus { finished_airing, currently_airing, not_yet_aired, unknown }

class AiringStatusUtil {
  static AiringStatus getFromFormatedString(String ch) {
    switch (ch) {
      case "finished_airing":
        return AiringStatus.finished_airing;
      case "currently_airing":
        return AiringStatus.currently_airing;
      case "not_yet_aired":
        return AiringStatus.not_yet_aired;
      case "unknown":
        return AiringStatus.unknown;
      default:
        return AiringStatus.unknown;
    }
  }
}

extension AiringStatusExtension on AiringStatus {
  String get name {
    switch (this) {
      case AiringStatus.currently_airing:
        return "currently airing";
      case AiringStatus.finished_airing:
        return "finished airing";
      case AiringStatus.not_yet_aired:
        return "not yet aired";
      case AiringStatus.unknown:
        return "unknown";
    }
  }
}

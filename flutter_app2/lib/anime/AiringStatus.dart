class AiringStatus {
  final _value;
  const AiringStatus._internal(this._value);
  toString() => 'Enum.$_value';

  static const FINISHED_AIRING =
      const AiringStatus._internal('finished_airing');
  static const CURRENTLY_AIRING =
      const AiringStatus._internal('currently_airing');
  static const NOT_YET_AIRED = const AiringStatus._internal('not_yet_aired');
  static const UNKNOWN = const AiringStatus._internal('unknown');

  static AiringStatus getFromFormatedString(String ch) {
    switch (ch) {
      case "finished_airing":
        return AiringStatus.FINISHED_AIRING;
      case "currently_airing":
        return AiringStatus.CURRENTLY_AIRING;
      case "not_yet_aired":
        return AiringStatus.NOT_YET_AIRED;
      default:
        return AiringStatus.UNKNOWN;
    }
  }

  String displayName() {
    switch (this) {
      case AiringStatus.CURRENTLY_AIRING:
        return "currently airing";
      case AiringStatus.FINISHED_AIRING:
        return "finished airing";
      case AiringStatus.NOT_YET_AIRED:
        return "not yet aired";
      case AiringStatus.UNKNOWN:
        return "unknown";
    }
  }
}

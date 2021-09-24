enum AiringStatus{
  finished_airing,
  currently_airing,
  not_yet_aired
}



class AiringStatusUtil {
  static AiringStatus getFromFormatedString(String ch) {
    switch (ch) {
      case "finished_airing":
        return AiringStatus.finished_airing;
      case "currently_airing":
        return AiringStatus.currently_airing;
      case "not_yet_aired":
        return AiringStatus.not_yet_aired;
    }
  }
}

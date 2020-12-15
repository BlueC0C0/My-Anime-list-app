enum ListStatus{
  watching,
  completed,
  on_hold,
  dropped,
  plan_to_watch,
  none
}

extension ListStatusExtension on ListStatus {

  String get name {
    switch(this) {
      case ListStatus.completed:
        return "ccompleted";
      case ListStatus.dropped:
        return "dropped";
      case ListStatus.on_hold:
        return "on hold";
      case ListStatus.plan_to_watch:
        return "plan to watch";
      case ListStatus.watching:
        return "watching";
      case ListStatus.none:
        return "not yet in list";
    }
  }

  ListStatus getListStatus(String chaine){
    switch(chaine) {
      case "completed":
        return ListStatus.completed;
      case "dropped":
        return ListStatus.dropped;
      case "on_hold":
        return ListStatus.on_hold;
      case "plan_to_watch":
        return ListStatus.plan_to_watch;
      case "watching":
        return ListStatus.watching;
    }

  }

}
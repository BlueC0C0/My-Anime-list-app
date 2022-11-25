import 'dart:ui';

enum ListStatus {
  all,
  watching,
  completed,
  paused,
  dropped,
  plan_to_watch,
  none
}

extension ListStatusExtension on ListStatus {
  String get name {
    switch (this) {
      case ListStatus.all:
        return "all";
      case ListStatus.completed:
        return "completed";
      case ListStatus.dropped:
        return "dropped";
      case ListStatus.paused:
        return "paused";
      case ListStatus.plan_to_watch:
        return "planned";
      case ListStatus.watching:
        return "watching";
      case ListStatus.none:
        return "not in list";
    }
  }

  Color get color {
    switch (this) {
      case ListStatus.completed:
        return Color.fromRGBO(34, 64, 174, 1);
      case ListStatus.dropped:
        return Color.fromRGBO(192, 38, 52, 1);
      case ListStatus.paused:
        return Color.fromRGBO(144, 123, 16, 1);
      case ListStatus.plan_to_watch:
        return Color.fromRGBO(85, 85, 85, 1);
      case ListStatus.watching:
        return Color.fromRGBO(20, 92, 19, 1);
      case ListStatus.none:
        return Color.fromARGB(255, 44, 44, 44);
    }
  }

  String get encodeName {
    switch (this) {
      case ListStatus.all:
        return "";
      case ListStatus.completed:
        return "completed";
      case ListStatus.dropped:
        return "dropped";
      case ListStatus.paused:
        return "on_hold";
      case ListStatus.plan_to_watch:
        return "plan_to_watch";
      case ListStatus.watching:
        return "watching";
      case ListStatus.none:
        return "none";
    }
  }
}

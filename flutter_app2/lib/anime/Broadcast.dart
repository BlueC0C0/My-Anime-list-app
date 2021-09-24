import 'package:flutter/material.dart';

class Broadcast {
  int dayOfWeek;
  TimeOfDay time;

  Broadcast(this.dayOfWeek, this.time);

  factory Broadcast.fromJson(dynamic json) {
    if(json!=null) {
      int dayOfWeek;
      TimeOfDay time;

      switch(json["day_of_the_week"]){
        case 'monday':
          dayOfWeek = 1;
          break;
        case 'tuesday':
          dayOfWeek = 2;
          break;
        case 'wednesday':
          dayOfWeek = 3;
          break;
        case 'thrusday':
          dayOfWeek = 4;
          break;
        case 'friday':
          dayOfWeek = 5;
          break;
        case 'saturday':
          dayOfWeek = 6;
          break;
        case 'sunday':
          dayOfWeek = 7;
          break;
        default:
          dayOfWeek = 0;
          break;
      }

      String hour = json["start_time"] ?? "0:0";

      time = TimeOfDay(minute: int.parse(hour.split(":")[1]),hour: int.parse(hour.split(":")[0]));

      return Broadcast(dayOfWeek,time);
    }
    else
      return Broadcast(1,TimeOfDay(minute: 0,hour: 0));
  }

  @override
  String toString() {
    return '{ ${this.dayOfWeek}, ${this.time}}';
  }

}
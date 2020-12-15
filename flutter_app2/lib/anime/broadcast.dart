class Broadcast{
  String day;
  String hour;

  Broadcast(this.day,this.hour);

  factory Broadcast.fromJson(dynamic json) {
    if(json != null)
      return Broadcast(json['day_of_the_week'] as String, json['start_time'] as String );
    else
      return Broadcast("NC","NC");
  }

  @override
  String toString() {
    return '{ ${this.day}, ${this.hour}}';
  }
}
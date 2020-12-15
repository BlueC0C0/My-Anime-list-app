
class Picture{
  String medium;
  String large;

  Picture(this.medium,this.large);

  factory Picture.fromJson(dynamic json) {
    return Picture(json['medium'] as String, json['large'] as String );
  }

  @override
  String toString() {
    return '{ ${this.medium}, ${this.large}}';
  }
}




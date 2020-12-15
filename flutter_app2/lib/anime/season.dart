

class Season {
  String periode;
  int annee;

  Season(this.annee,this.periode);

  factory Season.fromJson(dynamic json) {
    if(json!=null)
      return Season(json['year'] as int, json['season'] as String );
    else
      return Season(0,"NC");
  }

  @override
  String toString() {
    return '{ ${this.annee}, ${this.periode}}';
  }
}
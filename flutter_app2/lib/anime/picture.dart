
class Picture{
  String medium;
  String large;

  Picture(this.medium,this.large);

  factory Picture.fromJson(dynamic json) {
    if(json != null) {
      return Picture(json['medium'] as String ?? "https://image.shutterstock.com/image-vector/black-cat-silhouette-elegant-sitting-260nw-735404302.jpg",
          json['large'] as String ?? "https://image.shutterstock.com/image-vector/black-cat-silhouette-elegant-sitting-260nw-735404302.jpg");
    } else {
      return Picture("https://image.shutterstock.com/image-vector/black-cat-silhouette-elegant-sitting-260nw-735404302.jpg",
          "https://image.shutterstock.com/image-vector/black-cat-silhouette-elegant-sitting-260nw-735404302.jpg");
    }

  }

  @override
  String toString() {
    return '{ ${this.medium}, ${this.large}}';
  }
}




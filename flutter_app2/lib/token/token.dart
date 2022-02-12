class Token {
  String token_type;
  String access_token;
  String refresh_token;
  DateTime expiration_date;

  Token(
      this.token_type, this.access_token, this.refresh_token, int expires_in) {
    expiration_date = DateTime.now().add(Duration(seconds: expires_in));
    print("date actuelle : " + DateTime.now().toString());
    print("date fin du token : " + expiration_date.toString());
  }

  Token._(this.token_type, this.access_token, this.refresh_token,
      this.expiration_date);

  static Token fromJson(dynamic json) {
    if (json['token_type'] == null) {
      return null;
    }
    if (json["expiration_date"] != null)
      return Token._(
          json['token_type'] as String,
          json['access_token'] as String,
          json['refresh_token'] as String,
          DateTime.parse(json["expiration_date"]));
    else
      return Token(json['token_type'] as String, json['access_token'] as String,
          json['refresh_token'] as String, json['expires_in'] as int);
  }

  @override
  String toString() {
    return '{ ${this.token_type}, ${this.access_token}, ${this.refresh_token},${this.expiration_date} }';
  }

  Map<String, dynamic> toJson() => {
        'token_type': token_type,
        'access_token': access_token,
        'refresh_token': refresh_token,
        'expiration_date': expiration_date.toIso8601String(),
      };
}

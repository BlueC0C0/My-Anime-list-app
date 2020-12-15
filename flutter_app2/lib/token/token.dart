class Token {
  String token_type;
  int expires_in;
  String access_token;
  String refresh_token;
  DateTime dateFin;

  Token(this.token_type,this.expires_in,this.access_token,this.refresh_token) {
    dateFin = DateTime.now().add(Duration(seconds: expires_in));
  }

  factory Token.fromJson(dynamic json) {
    return Token(json['token_type'] as String, json['expires_in'] as int,json['access_token'] as String,json['refresh_token'] as String);
  }

  @override
  String toString() {
    return '{ ${this.token_type}, ${this.expires_in}, ${this.access_token}, ${this.refresh_token} }';
  }
  Map<String, dynamic> toJson() => {
  'token_type' :token_type,
  'expires_in' : expires_in,
  'access_token' :access_token,
  'refresh_token' :refresh_token,
  };

}


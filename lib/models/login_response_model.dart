class LoginResponse {
  String? accessToken;
  String? refreshToken;
  String? name;

  LoginResponse({this.accessToken, this.refreshToken, this.name});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['AccessToken'];
    refreshToken = json['RefreshToken'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AccessToken'] = accessToken;
    data['RefreshToken'] = refreshToken;
    data['Name'] = name;
    return data;
  }
}

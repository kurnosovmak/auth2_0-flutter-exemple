class Auth {
  final String accessToken;
  final String refreshToken;

  Auth({required this.accessToken, required this.refreshToken});
  Auth.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];

  Map<String, dynamic> toJson() =>
      {'accessToken': accessToken, 'refreshToken': refreshToken};
}

class RegistrationRequest {
  String username;
  String password;

  RegistrationRequest({required this.username, required this.password});

  Map toJson() {
    Map map = {
      'username': username.trim(),
      'password': password.trim(),
    };

    return map;
  }
}

class RegistrationResponse {
  String username;
  String error;
  int statusCode;

  RegistrationResponse(
      {required this.username, required this.error, required this.statusCode});

  factory RegistrationResponse.fromJson(Map json, int statusCode) {
    return RegistrationResponse(
        username: json["username"] ?? "",
        error: json["error"] ?? "",
        statusCode: statusCode);
  }
}

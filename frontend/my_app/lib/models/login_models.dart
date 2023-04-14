import 'dart:io';

class LoginRequest {
  String username;
  String password;

  LoginRequest({required this.username, required this.password});

  Map toJson() {
    Map map = {
      'username': username.trim(),
      'password': password.trim(),
    };

    return map;
  }
}

class LoginResponse {
  String username;
  String error;
  int statusCode;

  LoginResponse(
      {required this.username, required this.error, required this.statusCode});

  factory LoginResponse.fromJson(Map json, int statusCode) {
    return LoginResponse(
        username: json["username"] ?? "",
        error: json["error"] ?? "",
        statusCode: statusCode);
  }
}

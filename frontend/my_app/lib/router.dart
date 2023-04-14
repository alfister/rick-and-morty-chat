import 'package:flutter/material.dart';
import 'package:my_app/pages/login_page.dart';
import 'package:my_app/pages/registration_page.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouterConstants.baseRoute:
      return MaterialPageRoute(builder: (_) => LoginPage());
    case RouterConstants.loginRoute:
      return MaterialPageRoute(builder: (_) => LoginPage());
    case RouterConstants.registrationRoute:
      return MaterialPageRoute(builder: (_) => RegistrationPage());
    case RouterConstants.homeRoute:
      return MaterialPageRoute(builder: (_) => HomePage());
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}'))));
  }
}

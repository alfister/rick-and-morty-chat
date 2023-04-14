import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //// application root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat Login',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
          textTheme: TextTheme(
            displayLarge: TextStyle(fontSize: 22.0, color: Colors.redAccent),
            displayMedium: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
            ),
            bodyLarge: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Colors.blueAccent,
            ),
          ),
        ),
        onGenerateRoute: generateRoute,
        initialRoute: RouterConstants.registrationRoute);
  }
}

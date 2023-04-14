import 'package:flutter/material.dart';
import 'package:my_app/models/login_models.dart';
import 'package:my_app/constants.dart' as constants;
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> loginFormStateKey = GlobalKey<FormState>();
  bool hidePassword = true;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //// user login
  Future<LoginResponse> userLogin() async {
    String username = usernameController.text;
    String password = passwordController.text;

    String url = "http://128.61.55.52:5000/login";
    LoginRequest req = LoginRequest(username: username, password: password);

    final response = await http.post(Uri.parse(url), body: req.toJson());

    print(jsonDecode(response.body));
    return LoginResponse.fromJson(
        jsonDecode(response.body), response.statusCode);
  }

  //// clears form and navigates to home page
  void handleLoginResponse(LoginResponse res) {
    switch (res.statusCode) {
      case 200:
        loginFormStateKey.currentState?.reset();
        Navigator.pushNamed(context, constants.RouterConstants.homeRoute);
        break;
      case 401:
        SnackBar snackBar =
            SnackBar(content: Text(res.error), duration: Duration(seconds: 3));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      case 404:
        SnackBar snackBar =
            SnackBar(content: Text(res.error), duration: Duration(seconds: 3));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: loginScaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            offset: Offset(0, 10),
                            blurRadius: 20)
                      ]),
                  child: Form(
                      key: loginFormStateKey,
                      child: Column(children: <Widget>[
                        SizedBox(height: 25),
                        Text("Login",
                            style: Theme.of(context).textTheme.headlineMedium),
                        SizedBox(height: 20),
                        TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                                hintText: "Username",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                prefixIcon: Icon(Icons.login,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary))),
                        SizedBox(height: 20),
                        TextFormField(
                            validator: (input) => input != null &&
                                    input.length < 8
                                ? "Password length must be at least 8 characters"
                                : null,
                            controller: passwordController,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                                hintText: "Password",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                prefixIcon: Icon(Icons.lock_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: Icon(hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.4)))),
                        SizedBox(height: 30),
                        TextButton(
                          onPressed: () {
                            userLogin().then((LoginResponse res) {
                              handleLoginResponse(res);
                            });
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 80),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              shape: StadiumBorder()),
                          child: Text("Login",
                              style: TextStyle(color: Colors.white)),
                        )
                      ])))
            ])
          ],
        )));
  }
}

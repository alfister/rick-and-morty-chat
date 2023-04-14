import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/constants.dart' as constants;
import 'package:my_app/models/registration_models.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final registrationScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> registrationFormStateKey = GlobalKey<FormState>();
  bool hidePassword = true;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //// registers new user
  Future<RegistrationResponse> userRegistration() async {
    String username = usernameController.text;
    String password = passwordController.text;

    String url = "http://128.61.55.52:5000/register";
    RegistrationRequest req =
        RegistrationRequest(username: username, password: password);

    final response = await http.post(Uri.parse(url), body: req.toJson());
    print(jsonDecode(response.body));
    return RegistrationResponse.fromJson(
        jsonDecode(response.body), response.statusCode);
  }

  //// reset form and navigates to login page
  void handleRegistrationResponse(RegistrationResponse res) {
    switch (res.statusCode) {
      case 200:
        registrationFormStateKey.currentState?.reset();
        Navigator.pushNamed(context, constants.RouterConstants.loginRoute);
        break;
      case 400:
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
        key: registrationScaffoldKey,
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
                      key: registrationFormStateKey,
                      child: Column(children: <Widget>[
                        SizedBox(height: 25),
                        Text("Register",
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
                            userRegistration().then((RegistrationResponse res) {
                              handleRegistrationResponse(res);
                            });
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 80),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              shape: StadiumBorder()),
                          child: Text("Register",
                              style: TextStyle(color: Colors.white)),
                        )
                      ])))
            ])
          ],
        )));
  }
}

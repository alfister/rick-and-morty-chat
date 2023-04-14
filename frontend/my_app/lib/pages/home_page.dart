import 'package:flutter/material.dart';
import 'package:my_app/chat/chats.dart';
import 'package:my_app/chat/chat_spotlight.dart';
import 'package:my_app/models/user_models.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey homeScaffoldKey = GlobalKey<ScaffoldState>();
  User spotlightUser = User(id: -1, username: "Welcome");

  callback(User newSpotlightUser) {
    setState(() {
      spotlightUser = newSpotlightUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary),
                  child: Column(
                    children: <Widget>[
                      Chats(spotlightUser: spotlightUser, callback: callback)
                    ],
                  ))),
          Expanded(
              flex: 2,
              child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: ChatSpotlight(spotlightUser: spotlightUser))),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_app/models/message_models.dart';
import 'package:my_app/models/user_models.dart';
import 'package:my_app/chat/chat_spotlight.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chats extends StatefulWidget {
  Function callback;
  User spotlightUser;

  Chats({required this.callback, required this.spotlightUser});

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  Future<ChatsResponse> getChats() async {
    String url = "http://128.61.55.52:5000/home/get-chats";
    final response = await http.get(Uri.parse(url));

    print(jsonDecode(response.body));
    return ChatsResponse.fromJson(
        jsonDecode(response.body), response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(color: Colors.purple),
            child: FutureBuilder(
                future: getChats(),
                builder:
                    (BuildContext ctx, AsyncSnapshot<ChatsResponse> chatsRes) {
                  if (chatsRes.hasData) {
                    List<dynamic> chatsDynamic = chatsRes.data!.chats;

                    List<User> chats = [];
                    for (var chat in chatsDynamic) {
                      User user =
                          User(id: chat['_id'], username: chat['username']);
                      chats.add(user);
                    }

                    return ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                widget
                                    .callback(chats[chats.length - index - 1]);
                              },
                              // onTap: () {
                              //   print(index.toString() + ' tapped');
                              // },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  margin: EdgeInsets.only(
                                      top: 5.0, bottom: 5.0, right: 20.0),
                                  decoration: BoxDecoration(
                                      color: Colors.yellowAccent,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0))),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: <Widget>[
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    chats[chats.length -
                                                            index -
                                                            1]
                                                        .username,
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ])
                                        ])
                                      ])));
                        });
                  } else {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                })));
  }
}

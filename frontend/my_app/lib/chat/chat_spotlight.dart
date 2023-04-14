import 'package:flutter/material.dart';
import 'package:my_app/models/user_models.dart';
import 'package:my_app/models/message_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatSpotlight extends StatefulWidget {
  final User spotlightUser; // user that we're chatting with
  ChatSpotlight({required this.spotlightUser});

  @override
  _ChatSpotlightState createState() => _ChatSpotlightState();
}

class _ChatSpotlightState extends State<ChatSpotlight> {
  final newMessageController = TextEditingController();

  //// puts user-created message in database
  Future<NewMessageResponse> sendNewMessage() async {
    String url =
        "http://128.61.55.52:5000/home/send-message?user_id=${widget.spotlightUser.id}";
    String newMessage = newMessageController.text;
    NewMessageRequest req = NewMessageRequest(content: newMessage);

    final response = await http.post(Uri.parse(url), body: req.toJson());

    newMessageController.clear();
    setState(() {});

    print(jsonDecode(response.body));
    return NewMessageResponse.fromJson(
        jsonDecode(response.body), response.statusCode);
  }

  //// gets a chat with one contact
  Future<OneChatResponse> getOneChat() async {
    String url =
        "http://128.61.55.52:5000/home/get-one-chat?user_id=${widget.spotlightUser.id}";
    final response = await http.get(Uri.parse(url));

    print(jsonDecode(response.body));
    return OneChatResponse.fromJson(
        jsonDecode(response.body), response.statusCode);
  }

  //// conversation bubbles on main screen
  buildMessage(Message message, bool sentByMe) {
    return Container(
        margin: sentByMe
            ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
            : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        decoration: BoxDecoration(
            color: sentByMe ? Colors.green : Colors.blue,
            borderRadius: sentByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0))
                : BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(message.time,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 7.0),
              Text(message.content,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600))
            ]));
  }

  //// user input component
  buildMessageComposer() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: 70.0,
        color: Colors.white,
        child: Row(children: <Widget>[
          Expanded(
              child: TextField(
                  controller: newMessageController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration:
                      InputDecoration.collapsed(hintText: 'Send a message!'))),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 20.0,
            color: Colors.red,
            onPressed: () {
              sendNewMessage();
            },
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(widget.spotlightUser.username,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
        body: Column(children: <Widget>[
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: FutureBuilder(
                      future: getOneChat(),
                      builder: (BuildContext ctx,
                          AsyncSnapshot<OneChatResponse> oneChatRes) {
                        if (oneChatRes.hasData) {
                          List<dynamic> oneChatDynamic =
                              oneChatRes.data!.oneChat;

                          List<Message> messages = [];
                          for (var message in oneChatDynamic) {
                            Message msg = Message(
                                senderId: message['sender_id'],
                                time: message['time'],
                                content: message['content']);
                            messages.add(msg);
                          }

                          return ListView.builder(
                              // reverse: true,
                              padding: EdgeInsets.only(top: 10.0),
                              itemCount: messages.length,
                              itemBuilder: (BuildContext context, int index) {
                                bool sentByMe = messages[index].senderId ==
                                    11; // current user id
                                return buildMessage(messages[index], sentByMe);
                              });
                        } else {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      }))),
          buildMessageComposer()
        ]));
  }
}

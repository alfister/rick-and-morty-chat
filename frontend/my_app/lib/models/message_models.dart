class Message {
  final int senderId;
  final String time;
  final String content;

  Message({required this.senderId, required this.time, required this.content});
}

class NewMessageResponse {
  int senderId; // change back once actual id is
  String content;
  String time;
  int statusCode;

  NewMessageResponse(
      {required this.senderId,
      required this.content,
      required this.time,
      required this.statusCode});

  factory NewMessageResponse.fromJson(Map json, int statusCode) {
    return NewMessageResponse(
        senderId: json["sender_id"] ?? "",
        content: json["content"] ?? "",
        time: json["time"] ?? "",
        statusCode: statusCode);
  }
}

class NewMessageRequest {
  String content;

  NewMessageRequest({required this.content}); // sender id here?

  Map toJson() {
    Map map = {'content': content};

    return map;
  }
}

class ChatsResponse {
  List<dynamic> chats;
  int statusCode;

  ChatsResponse({required this.chats, required this.statusCode});

  factory ChatsResponse.fromJson(Map json, int statusCode) {
    return ChatsResponse(chats: json['chats'] ?? [], statusCode: statusCode);
  }
}

class OneChatResponse {
  List<dynamic> oneChat;
  int statusCode;

  OneChatResponse({required this.oneChat, required this.statusCode});

  factory OneChatResponse.fromJson(Map json, int statusCode) {
    return OneChatResponse(
        oneChat: json['one_chat'] ?? [], statusCode: statusCode);
  }
}

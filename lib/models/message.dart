import 'package:chat_app/widgets/constants.dart';
import 'package:flutter/foundation.dart';

class Message {
  final String? message;
  final String? id;

  Message({this.message,this.id});

  factory Message.fromjson(dynamic jsonData) {
    return Message(message: jsonData[KMessage],id: jsonData['id']);
  }
}

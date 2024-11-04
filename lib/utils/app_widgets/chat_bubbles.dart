
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

class ChatBubbles{

  static userMessage(String msg){
   return BubbleSpecialOne(
     text: msg,
     isSender: true,
     color: Colors.deepPurple.shade50,
     textStyle: TextStyle(
       fontSize: 12,
       color: Colors.deepPurple.shade400,
       fontStyle: FontStyle.italic,
       fontWeight: FontWeight.bold,
     ),
   );
  }

  static botMessage(String msg){
    return BubbleSpecialOne(
      text: msg,
      isSender: false,
      color: Colors.grey.shade200,
      textStyle: TextStyle(
        fontSize: 12,
        color: Colors.black45,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
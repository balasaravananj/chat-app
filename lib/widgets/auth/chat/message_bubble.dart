import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final Key key;
  final String username;
  final String userImage;

  MessageBubble(this.message,this.isUser,this.username,this.userImage,{this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Row(
        mainAxisAlignment: isUser?MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            width: 140,
            padding: EdgeInsets.symmetric(vertical:10,horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 16,horizontal: 8),
            decoration: BoxDecoration(
              color:isUser?Colors.grey[300]: Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isUser ? Radius.circular(0):Radius.circular(12),
                bottomRight: isUser? Radius.circular(0):Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment:isUser?CrossAxisAlignment.end:CrossAxisAlignment.start,
              children: [
                    Text(username,
                           style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:isUser?Colors.black: Theme.of(context).accentTextTheme.headline1.color,
                        ),
                    ),
                Text(
                  message,
                  style: TextStyle(
                  color:isUser?Colors.black: Theme.of(context).accentTextTheme.headline1.color),
                  textAlign:isUser?TextAlign.end:TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
        Positioned(
          top: 0,
          left: isUser?null: 120,
          right: isUser? 120:null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
    ],
      overflow: Overflow.visible,
    );
  }
}

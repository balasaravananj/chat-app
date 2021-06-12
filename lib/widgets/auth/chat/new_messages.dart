import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_emoji_keyboard/flutter_emoji_keyboard.dart';

class NewMessages extends StatefulWidget {


  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {

var _enteredMessage = '';
final _textController = TextEditingController();


void _sendMessage() async {
   FocusScope.of(context).unfocus();
   final user = await FirebaseAuth.instance.currentUser();
   final userData = await Firestore.instance.collection('users').document(user.uid).get();
   Firestore.instance.collection('chat').add({
     'text':_enteredMessage,
     'createdAt': Timestamp.now(),
     'userId': user.uid,
     'username': userData['username'],
     'userImage':userData['image_url'],
   });
   _textController.clear();
}

 void onEmojiSelected(Emoji emoji){
  _textController.text+=emoji.text;
 }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                controller: _textController,
                enableSuggestions: true,
                decoration:InputDecoration(labelText: 'Type a message...'),
                onChanged: (value){
                  setState(() {
                    _enteredMessage=value;
                  });
                },
              ),
            ),
            IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.send),
                onPressed:_enteredMessage.trim().isEmpty ? null :_sendMessage
            )
          ],
        ),
    );
  }
}




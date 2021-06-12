import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth= FirebaseAuth.instance;

  var _isLoading=false;

  void showErrorDialog(String message){
    showDialog(context: context,
        builder:(ctx)=>AlertDialog(
          title: Text('An error occurred!'),
          content: Text(message),
          actions: [
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('Okay'),
            )
          ],
        )
    );

  }

  void _submitAuthForm(
      String email,
      String userName,
      File userImage,
      String password,
      bool isLogin
      ) async{
    AuthResult authResult;
    try{
      setState(() {
        _isLoading=true;
      });
      if(isLogin){
        authResult=await _auth.signInWithEmailAndPassword(email: email, password: password);
      }
      else{
        authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);

        final ref=FirebaseStorage.instance.ref().child('user').child('${authResult.user.uid}').child(authResult.user.uid+'.jpg');
        await ref.putFile(userImage).onComplete;

        final url=await ref.getDownloadURL();

        await Firestore.instance.collection('users').document(authResult.user.uid).setData({
          'username':userName,
          'email':email,
          'image_url':url,
        });
      }

    }on PlatformException catch(error){
      var message='An error occurred, Please check your credentials!';
      if(error.message!=null){
        message=error.message;
      }
      showErrorDialog(message);
      setState(() {
        _isLoading=false;
      });
    }catch(error){
      print(error);
      setState(() {
        _isLoading=false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body:AuthForm(_submitAuthForm,_isLoading),
    );
  }
}

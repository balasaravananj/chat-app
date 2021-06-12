import 'package:chat_app/widgets/auth/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {

  final Function submitForm;
  final bool isLoading;
  AuthForm(this.submitForm,this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey=GlobalKey<FormState>();
  var _isLogin=true;
 String _userEmail='';
 String _userName='';
 String _password='';
 File _userImageFile;

 void _pickedImageFn(File pickedImage){
   _userImageFile=pickedImage;
 }


  void _trySubmit(){
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(!isValid&&_userImageFile==null){
      return;
    }
    _formKey.currentState.save();
    widget.submitForm(
        _userEmail.trim(),
        _userName.trim(),
        _userImageFile,
        _password,
        _isLogin);

  }


  @override
  Widget build(BuildContext context) {
    return  Center(
      child:Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(!_isLogin)
                UserImagePicker(_pickedImageFn),
                TextFormField(
                  key: ValueKey('email'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'E-mail Id'),
                  validator: (value){
                    if(value.isEmpty||!value.contains('@')){
                      return 'Please enter valid E-mail Id';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _userEmail=value;
                  },
                ),
                if(!_isLogin)
                TextFormField(
                  key: ValueKey('username'),
                  decoration: InputDecoration(labelText: 'User Name'),
                  validator: (value){
                    if(value.isEmpty||value.length<3){
                      return 'Please enter a valid user name';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _userName=value;
                  },
                ),
                TextFormField(
                  key: ValueKey('password'),
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value){
                    if(value.isEmpty){
                      return 'Please enter a valid password';
                    }
                    else if(value.length<6){
                      return 'Password must have at least 6 character';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _password=value;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                if(widget.isLoading)
                  CircularProgressIndicator(),
                if(!widget.isLoading)
                RaisedButton(child:_isLogin? Text('Login'):Text('Sign Up'),onPressed:_trySubmit),
                if(!widget.isLoading)
                FlatButton(
                  child:_isLogin?Text('Create New Account'):Text('Login Instead'),
                  textColor: Theme.of(context).primaryColor,
                  onPressed: (){
                    setState(() {
                      _isLogin=!_isLogin;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

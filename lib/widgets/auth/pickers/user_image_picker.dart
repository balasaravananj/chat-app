import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'dart:io';

class UserImagePicker extends StatefulWidget {

  final void Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  var _isInit =true;
  File _imageFile;

  @override
  void didChangeDependencies() async {
    if(_isInit){
      var bytes = await rootBundle.load('assets/images/user-image-default.jpg');
      String tempPath =(await path.getTemporaryDirectory()).path;
      File file=File('$tempPath/user-image-default.jpg');
      await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      setState(() {
        _imageFile=file;
      });
      widget.imagePickFn(_imageFile);
      _isInit=false;
    }
    super.didChangeDependencies();
  }


  void _pickImage(){

    showDialog(context: context, builder:(ctx)=>AlertDialog(
      title: Text('Set Profile Picture'),
      actions: [
        FlatButton(
          child: Text('Take Picture'),
          onPressed: ()async {
            Navigator.of(context).pop();
            var imageFile = await ImagePicker.pickImage(
                source: ImageSource.camera,
              imageQuality: 50,
              maxWidth: 150,
            );
            setState(() {
              _imageFile = imageFile;
            });
            widget.imagePickFn(_imageFile);
          },
        ),
        FlatButton(
          child: Text('Use Gallery'),
          onPressed: () async {
            Navigator.of(context).pop();
            var imageFile = await ImagePicker.pickImage(
                source: ImageSource.gallery,
              imageQuality: 50,
              maxWidth: 150,
            );
            setState(() {
              _imageFile = imageFile;
            });
            widget.imagePickFn(_imageFile);
          },
        ),
      ],
    )
    );

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 50,
          backgroundImage:_imageFile!=null ? FileImage(_imageFile):null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.image),
          label: Text('Set Picture'),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}

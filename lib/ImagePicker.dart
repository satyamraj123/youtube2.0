import 'package:image_picker/image_picker.dart';
import "package:flutter/material.dart";
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.pickImageFn);
  final void Function(File pickedImage) pickImageFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final pickedImage = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    setState(() {
      _pickedImage = pickedImage;
    });

    widget.pickImageFn(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 40,
            backgroundImage:
                _pickedImage != null ? FileImage(_pickedImage) : null),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text(
              'Add Image',
            )),
      ],
    );
  }
}

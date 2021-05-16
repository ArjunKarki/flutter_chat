import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function pickImage;

  UserImagePicker(this.pickImage);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;
  void _getImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 150,
    );
    setState(() {
      _image = File(pickedFile.path);
    });
    widget.pickImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: _image != null ? FileImage(_image) : null,
            backgroundColor: Colors.pink,
          ),
          TextButton.icon(
            onPressed: _getImage,
            icon: Icon(
              Icons.image,
              color: Colors.pink,
            ),
            label: Text(
              "Pick Image",
              style: TextStyle(color: Colors.pink),
            ),
          )
        ],
      ),
    );
  }
}

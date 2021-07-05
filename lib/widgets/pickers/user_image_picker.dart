import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  html.File _selectedImage;

  void _pickImage() async {
    if (kIsWeb) {
      html.InputElement uploadInput = html.FileUploadInputElement()
        ..accept = 'image/*';
      uploadInput.click();
      uploadInput.onChange.listen((event) {
        final file = uploadInput.files.first;
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoad.listen((event) {
          setState(() {
            _selectedImage = file;
          });
        });
      });
    } else {
      final pickedImageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 150,
        imageQuality: 100,
      );
      setState(() {
        _pickedImage = pickedImageFile;
      });
      widget.imagePickFn(pickedImageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
          
        ),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text('Add Image')),
      ],
    );
  }
}

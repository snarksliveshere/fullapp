import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {

  @override
  State createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(
        source: source,
        maxWidth: 400.0
    )
    .then((File image) {
      Navigator.pop(context);
    })
    ;
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Text('Pick an Image'),
                SizedBox(height: 10.0,),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                      'Use Camera',
                      style: TextStyle(
                        fontWeight: FontWeight.w700
                      ),
                  ),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                SizedBox(height: 10.0,),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = Theme.of(context).accentColor;
    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(
            color: buttonColor,
            width: 2.0
          ),
          onPressed: () {
            _openImagePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.camera_alt, color: buttonColor),
              SizedBox(width: 5.0),
              Text(
                'Add Image',
                style: TextStyle(
                  color: buttonColor
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

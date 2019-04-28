import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {

  @override
  State createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
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

import 'package:flutter/material.dart';

class ProductAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        child: Text(
            'Union Square, San Francisco',
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700
            ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5));
  }
}

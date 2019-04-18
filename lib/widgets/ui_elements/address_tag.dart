import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {
  final String _address;

  AddressTag(this._address);

  @override
  Widget build(BuildContext context) {
    return Padding(
        child: Text(
            this._address,
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700
            ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5));
  }
}

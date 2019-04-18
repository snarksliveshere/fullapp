import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _emailValue;
  String _passwordValue;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login')
      ),
      body: _authForm()
    );
  }

  Widget _authForm() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Enter e-mail',
            ),
            onChanged: (String value) {
              setState(() {
                this._emailValue = value;
              });
            },
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Enter your password',
            ),
            onChanged: (String value) {
              setState(() {
                this._passwordValue = value;
              });
            },
          ),
          SwitchListTile(
              title: Text('Accept terms'),
              value: _acceptTerms,
              onChanged: (bool value) {
                setState(() {
                  this._acceptTerms = value;
                });
              }
          ),
          SizedBox(height: 10.0),
          RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () => {
                debugPrint(this._emailValue),
                debugPrint(this._passwordValue),
                Navigator.pushReplacementNamed(context, '/products')
              },
              child: Text('Login')
          )
        ],
      )
    );
  }
}
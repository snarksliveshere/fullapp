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
    return Scaffold(appBar: AppBar(title: Text('Login')), body: _authForm());
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        image: AssetImage('assets/background.jpg'),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop));
  }

  Widget _buildEmailTextField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Enter e-mail', filled: true, fillColor: Colors.white),
      onChanged: (String value) {
        setState(() {
          this._emailValue = value;
        });
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Enter your password',
          filled: true,
          fillColor: Colors.white),
      onChanged: (String value) {
        setState(() {
          this._passwordValue = value;
        });
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
        title: Text('Accept terms'),
        value: _acceptTerms,
        onChanged: (bool value) {
          setState(() {
            this._acceptTerms = value;
          });
        });
  }

  void _submitForm() {
    debugPrint(this._emailValue);
    debugPrint(this._passwordValue);
    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _authForm() {
    // i think, orientation better
//    final orientation = MediaQuery.of(context).orientation = Orientation.landscape
    final double deviceWidth =  MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 :  deviceWidth * 0.95;
    return Container(
      decoration: BoxDecoration(image: _buildBackgroundImage()),
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: targetWidth,
            child: Column(
              children: <Widget>[
                _buildEmailTextField(),
                SizedBox(
                  height: 10.0,
                ),
                _buildPasswordTextField(),
                _buildAcceptSwitch(),
                SizedBox(height: 10.0),
                RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: _submitForm,
                    child: Text('Login'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Enter e-mail', filled: true, fillColor: Colors.white
      ),
      validator: (String value) {
        if (value.isEmpty || !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value) ) {
          return 'Login is required and should be a valid email address';
        }
      },
      onSaved: (String value) {
        this._emailValue = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Enter your password',
          filled: true,
          fillColor: Colors.white
      ),
      validator: (String value) {
        if (value.isEmpty || value.length <= 4 ) {
          return 'Title is required and should be 5+ characters long';
        }
      },
      onSaved: (String value) {
        this._passwordValue = value;
      }
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
        subtitle: _acceptTerms ?  Text('') : Text('Must be accepted', style: TextStyle(color: Colors.red),),
        title: Text('Accept terms'),
        value: _acceptTerms,
        onChanged: (bool value) {
          setState(() {
            this._acceptTerms = value;
          });
        });
  }

  void _submitForm() {
    if (!_formKey.currentState.validate() || !_acceptTerms) {
      return;
    }
    _formKey.currentState.save();
    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _authForm() {
    // i think, orientation better
//    final orientation = MediaQuery.of(context).orientation = Orientation.landscape
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Form(
      key: _formKey,
      child: Container(
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
                      textColor: Colors.white,
                      onPressed: _submitForm,
                      child: Text('Login'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

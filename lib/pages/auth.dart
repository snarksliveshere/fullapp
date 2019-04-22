import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';

enum AuthMode {
  Signup,
  Login
}

class AuthPage extends StatefulWidget {
  @override
  State createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';
  static const String ACCEPT_TERMS = 'acceptTerms';

  final Map<String, dynamic> _formData = {
    EMAIL: null,
    PASSWORD: null,
    ACCEPT_TERMS: false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

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
        _formData[EMAIL] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Confirm password', filled: true, fillColor: Colors.white
      ),
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Please enter the valid password';
        }
      },
      onSaved: (String value) {
        _formData[PASSWORD] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordTextController,
      decoration: InputDecoration(
          labelText: 'Enter your password',
          filled: true,
          fillColor: Colors.white
      ),
      validator: (String value) {
        if (value.isEmpty || value.length < 5 ) {
          return 'Password is required and should be 5+ characters long';
        }
      },
      onSaved: (String value) {
        _formData[PASSWORD] = value;
      }
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
        subtitle: _formData[ACCEPT_TERMS]
            ? Text('')
            : Text(
                'Must be accepted',
                style: TextStyle(color: Colors.red),
              ),
        title: Text(ACCEPT_TERMS),
        value: _formData[ACCEPT_TERMS],
        onChanged: (bool value) {
          setState(() {
            _formData[ACCEPT_TERMS] = value;
          });
        });
  }

  void _submitForm(Function login) {
    if (!_formKey.currentState.validate() || !_formData[ACCEPT_TERMS]) {
      return;
    }
    _formKey.currentState.save();
    login(_formData['email'], _formData['password']);
    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _authForm() {
    // i think, orientation better
//    final orientation = MediaQuery.of(context).orientation = Orientation.landscape
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Container(
      decoration: BoxDecoration(image: _buildBackgroundImage()),
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: targetWidth,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _buildEmailTextField(),
                  SizedBox(height: 10.0,),
                  _buildPasswordTextField(),
                  SizedBox(height: 10.0),
                  _authMode == AuthMode.Signup ? _buildPasswordConfirmTextField() : Container(),
                  _buildAcceptSwitch(),
                  FlatButton(
                    child: Text('Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'login'}'),
                    onPressed: () {
                      setState(() {
                        _authMode = _authMode == AuthMode.Login
                            ? AuthMode.Signup
                            : AuthMode.Login;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  ScopedModelDescendant<MainModel>(
                    builder: (BuildContext context, Widget child, MainModel model) {
                      return RaisedButton(
                          textColor: Colors.white,
                          onPressed: () => _submitForm(model.login),
                          child: Text('Login'));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

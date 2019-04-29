import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';
import '../models/auth.dart';

class AuthPage extends StatefulWidget {
  @override
  State createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
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
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
    super.initState();
  }

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
    return FadeTransition(
      opacity: CurvedAnimation(
          parent: _controller,
          curve: Curves.easeIn
      ),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'Confirm password', filled: true, fillColor: Colors.white
        ),
        validator: (String value) {
          if (_passwordTextController.text != value && _authMode == AuthMode.Signup) {
            return 'Please enter the valid password';
          }
        },
      ),
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

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await authenticate(_formData['email'], _formData['password'], _authMode);
    if (successInformation['success']) {
//      Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
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
                  _buildPasswordConfirmTextField(),
                  _buildAcceptSwitch(),
                  FlatButton(
                    child: Text('Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'login'}'),
                    onPressed: () {
                      setState(() {
                        if (_authMode == AuthMode.Login) {
                          setState(() {
                            _authMode = AuthMode.Signup;
                          });
                          _controller.forward();
                        } else {
                          setState(() {
                            _authMode = AuthMode.Login;
                          });
                          _controller.reverse();
                        }
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  ScopedModelDescendant<MainModel>(
                    builder: (BuildContext context, Widget child, MainModel model) {
                      return model.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : RaisedButton(
                          textColor: Colors.white,
                          onPressed: () => _submitForm(model.authenticate),
                          child: Text(_authMode == AuthMode.Login ? 'Login' : 'Signup'))
                      ;
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

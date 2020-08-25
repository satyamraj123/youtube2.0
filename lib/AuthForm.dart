import 'package:flutter/material.dart';
import 'dart:io';
import 'ImagePicker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this._isLoading);
  final bool _isLoading;
  final void Function(String email, String name, String password, File image,
      bool isLogin, BuildContext context) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  String _userEmail = '';
  String _name = '';
  String _userPassword = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formkey.currentState.validate();

    FocusScope.of(context).unfocus();
/* 
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
 */
    if (isValid) {
      _formkey.currentState.save();
      /* print(_userEmail);
      print(_userPassword);
      print(_userName); */

      widget.submitFn(_userEmail.trim(), _name.trim(), _userPassword.trim(),
          _userImageFile, _isLogin, context);
      //send the values
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid Email Address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('Name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Name'),
                      onSaved: (value) {
                        _name = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'Password must be atleast 6 characters long.';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 6) {
                          return 'Password must be atleast 6 characters long.';
                        } else if (value.toString() !=
                            _passwordController.text.toString()) {
                          return 'Password do not match';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                  SizedBox(
                    height: 12,
                  ),
                  widget._isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          color: Colors.red,
                          child: Text(_isLogin ? 'Login' : 'Signup'),
                          onPressed: _trySubmit,
                        ),
                  if (!widget._isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(_isLogin
                          ? 'Haven\'t registered yet? '
                          : 'Already have an Account?'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

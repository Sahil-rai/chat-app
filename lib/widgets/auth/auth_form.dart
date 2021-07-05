import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isloading);
  final bool isloading;
  final void Function(
    String email,
    String password,
    String username,
    File userImage,
    bool isLogin,
    BuildContext context,
  ) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userPassword = '';
  var _userName = '';
  File _userImageFile;
  var _isLogin = true;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();

      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
          left: width * 0.2,
          right: width * 0.2,
          bottom: _isLogin ? height * 0.3 : height * 0.15,
          top: height * 0.2),
      color: Color.fromRGBO(255, 255, 255, 0.8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "InfyGram",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.chat_bubble,
                      color: Colors.black,
                      size: 40,
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (!_isLogin) UserImagePicker(_pickedImage),
                          TextFormField(
                            key: ValueKey('email'),
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                            ),
                            onSaved: (value) {
                              _userEmail = value;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              key: ValueKey('username'),
                              validator: (value) {
                                if (value.isEmpty || value.length < 4) {
                                  return 'Please eneter atleast 4 characters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Username',
                              ),
                              onSaved: (value) {
                                _userName = value;
                              },
                            ),
                          TextFormField(
                            key: ValueKey('password'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 7) {
                                return 'Password must be at least 7 characters long';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            onSaved: (value) {
                              _userPassword = value;
                            },
                            obscureText: true,
                          ),
                          SizedBox(
                            height: _isLogin ? height * 0.05 : height * 0.03,
                          ),
                          if (widget.isloading) CircularProgressIndicator(),
                          if (!widget.isloading)
                            RaisedButton(
                              child: Text(
                                _isLogin ? 'Login' : 'Sign Up',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: _submit,
                            ),
                          if (!widget.isloading)
                            FlatButton(
                              textColor: Theme.of(context).primaryColor,
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? 'Create a new account'
                                    : 'I already have an account',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

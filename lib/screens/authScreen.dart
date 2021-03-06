import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/pickers/userImagePicker.dart';

class AuthScreen extends StatefulWidget {
  final bool isLoading;
  final Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    File proPic,
    BuildContext ctx,
  ) submitFn;
  AuthScreen(this.submitFn, this.isLoading);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String email = "";
  String password = "";
  String userName = "";
  File proPic;

  void _tryLogin() {
    bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (proPic == null && !isLogin) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Pleae pick a image")));
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(email.trim(), userName.trim(), password.trim(), isLogin,
          proPic, context);
    }
  }

  void _pickedImage(image) {
    proPic = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey("email"),
                    initialValue: "aks@gmail.com",
                    decoration: InputDecoration(labelText: "Enter your email"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "Please Enter Valid Email";
                      }
                      return null;
                    },
                    onSaved: (newValue) => email = newValue,
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey("username"),
                      decoration:
                          InputDecoration(labelText: "Enter your username"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your Username";
                        }
                        return null;
                      },
                      onSaved: (newValue) => userName = newValue,
                    ),
                  TextFormField(
                    obscureText: true,
                    key: ValueKey("password"),
                    decoration:
                        InputDecoration(labelText: "Enter your password"),
                    validator: (value) {
                      if (value.isEmpty || value.length < 1) {
                        return "Password must be at least four character";
                      }
                      return null;
                    },
                    onSaved: (newValue) => password = newValue,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  widget.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.pink),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: _tryLogin,
                          child: isLogin ? Text("Login") : Text("Signup"),
                        ),
                  if (!widget.isLoading)
                    TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? "create user account." : "I have an account.",
                        style: TextStyle(color: Colors.pink),
                      ),
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

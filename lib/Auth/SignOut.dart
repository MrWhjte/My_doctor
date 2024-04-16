import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Login.dart';

class SignOutUser
{
  final _auth= FirebaseAuth.instance;
  Future<void> logOut()async
  {
    try
    {
      await _auth.signOut();
      _goToLogIn;
    }catch(e)
    {
      Fluttertoast.showToast(msg: "Authentication error please try again");
    }
  }
  _goToLogIn(BuildContext context) =>
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login())
      );
}
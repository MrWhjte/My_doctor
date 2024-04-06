//
// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import 'Login.dart';
//
// class AuthService
// {
//     final _formkey = GlobalKey<FormState>();
//     final _auth= FirebaseAuth.instance;
//     Future<User?> createAccountUser(String nameUser,String email,String password)
//     async
//     {
//         try
//         {
//             final created = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//             Fluttertoast.showToast(msg: "Registered Successfully");
//             return created.user;
//         }catch(e)
//         {
//
//
//         }
//         return null;
//     }
//     Future<User?> loginWithAccount(String email,String password)async
//     {
//         try
//         {
//             final log= await _auth.signInWithEmailAndPassword(email: email, password: password);
//             return log.user;
//         }on FirebaseAuthException catch (e) {
//             if (e.code == 'user-not-found' || e.code == 'wrong-password') {
//                 Fluttertoast.showToast(msg: 'Invalid email or password.');
//             } else {
//                 Fluttertoast.showToast(msg: 'An error occurred: ${e.code}');
//             }
//
//         }
//         return null;
//     }
//
//     Future<void> logOut()async
//     {
//         try
//         {
//             await _auth.signOut();
//         }catch(e)
//         {
//             log("Have error");
//         }
//     }
//     _goToLogIn(BuildContext context) =>
//         Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const Login())
//         );
// }

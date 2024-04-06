import 'package:flutter/material.dart';
import 'Auth/Login.dart';
import 'Auth/signUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'other/openFile.dart';

void main()async
{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp( const MaterialApp(
            home: SafeArea(
                child: Scaffold(
                    // body: OpenGallery())),
                    body: Login())),
            debugShowCheckedModeBanner: false));
}

// class DemoApp extends StatelessWidget
// {
//     const DemoApp({super.key});
//
//     @override
//     Widget build(BuildContext context)
//     {
//         return Container(
//             margin: const EdgeInsets.all(10),
//             child: const Text('test',style: TextStyle(color: Colors.black,fontFamily: ,fontSize: 100))
//         );
//
//     }
// }

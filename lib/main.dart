import 'package:flutter/material.dart';
import 'package:my_doctor/screen/login.dart';

import 'other/openFile.dart';


void main()
{
    runApp( const MaterialApp(
            home: SafeArea(
                child: Scaffold(
                    body: OpenGallery())),
                    // body: Login())),
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

import 'package:flutter/material.dart';
import 'package:my_doctor/screen/login.dart';


void main()
{
    runApp(const MaterialApp(
            home: SafeArea(
                child: Scaffold(
                    // appBar: AppBar(
                    //     backgroundColor: Colors.blue,
                    //     title: const Text('Demo App',
                    //         style: TextStyle(
                    //             color: Colors.white, fontWeight: FontWeight.w700))),
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

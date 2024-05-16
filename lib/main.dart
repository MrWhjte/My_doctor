import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_doctor/Main_Function/splash_screen.dart';
import 'package:my_doctor/screens/NavigationMenu.dart';
import 'Auth/Login.dart';
import 'Auth/Reset_pass.dart';
import 'Auth/signUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:my_doctor/Main_Function/ScansScreen.dart';

void main()async
{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp( const GetMaterialApp(
            home: SafeArea(
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: NavigationMenu(index: 0,))),
                    // body: Splash())),
            debugShowCheckedModeBanner: false));
}


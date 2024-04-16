import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_doctor/Main_Function/splash_screen.dart';
import 'package:my_doctor/screens/NavigationMenu.dart';
import 'Auth/Login.dart';
import 'Auth/Forgot_Password.dart';
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
                    body: NavigationMenu())),
                    // body: Splash())),
            debugShowCheckedModeBanner: false));
}


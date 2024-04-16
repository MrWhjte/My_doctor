import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Auth/Login.dart';
import '../Main_Function/ForwardButton.dart';
import '../Main_Function/SettingItem.dart';
import 'EditAccountScreen.dart';

class Setting extends StatefulWidget
{
    const Setting({super.key});

    @override
    State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting>
{

    @override
    Widget build(BuildContext context)
    {
        return  Scaffold(

            body: SingleChildScrollView(
                child: Padding(
                    padding:  const EdgeInsets.all(25),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const Text(
                                "Settings",
                                style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                            const SizedBox(height: 40),
                            const Text(
                                "Account",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                                width: double.infinity,
                                child: Row(
                                    children: [
                                        Image.asset("assets/images/avatar.png", width: 70, height: 70),
                                        const SizedBox(width: 20),
                                        const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    "Your Name",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500,
                                                    ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                    "change your profile",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                    ),
                                                )
                                            ],
                                        ),
                                        const Spacer(),
                                        ForwardButton(
                                            onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => const EditAccountScreen(),
                                                    ),
                                                );
                                            },
                                        )
                                    ],
                                ),
                            ),
                            const SizedBox(height: 40),
                            const Text(
                                "Settings",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                ),
                            ),
                            const SizedBox(height: 20),
                            SettingItem(
                                title: "Language",
                                icon: Icons.language,
                                bgColor: Colors.orange.shade100,
                                iconColor: Colors.orange,
                                value: "English",
                                onTap: () {},
                            ),
                            const SizedBox(height: 20),
                            SettingItem(
                                title: "Notifications",
                                icon: Icons.notifications,
                                bgColor: Colors.blue.shade100,
                                iconColor: Colors.blue,
                                onTap: () {},
                            ),
                            const SizedBox(height: 20),
                            SettingItem(
                                title: "Help",
                                icon: Icons.help,
                                bgColor: Colors.red.shade100,
                                iconColor: Colors.red,
                                onTap: () {},
                            ),
                            const SizedBox(height: 20),
                            SettingItem(
                                title: "Logout",
                                icon: Icons.logout,
                                bgColor: Colors.purple.shade100,
                                iconColor: Colors.black,
                                onTap: () {
                                    logout();
                                    Fluttertoast.showToast(msg: 'logged out');
                                },
                            ),
                        ],
                    ),
                ),
            ),
        );
    }


    void logout()
    {
        FirebaseAuth.instance.signOut();
        _goToLogIn(context);
    }
    _goToLogIn(BuildContext context) =>
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login())
    );
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Auth/Login.dart';
import '../Main_Function/ForwardButton.dart';
import '../Main_Function/SettingItem.dart';
import 'AccountScreen.dart';
import 'EditAccountScreen.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  DatabaseReference? ref;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;
  String? idUser;
  String email = "";
  String yourName = "Chưa đặt tên";
  late String imageAvatar = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    await loadId();
    await loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cài đặt",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Tài Khoản",
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
                    imageAvatar.isNotEmpty
                        ? SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipOval(
                              child: Image.network(
                                imageAvatar,
                                fit: BoxFit.cover, // Cover the entire area
                              ),
                            ),
                          )
                        : Image.asset("assets/images/avatar.png",
                            width: 60, height: 60),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          yourName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Bấm để thay đổi thông tin",
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
                            builder: (context) => const AccountScreen(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Khác",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              // SettingItem(
              //   title: "Language",
              //   icon: Icons.language,
              //   bgColor: Colors.orange.shade100,
              //   iconColor: Colors.orange,
              //   value: "English",
              //   onTap: () {},
              // ),
              // const SizedBox(height: 20),
              // SettingItem(
              //   title: "Notifications",
              //   icon: Icons.notifications,
              //   bgColor: Colors.blue.shade100,
              //   iconColor: Colors.blue,
              //   onTap: () {},
              // ),
              // const SizedBox(height: 20),
              SettingItem(
                title: "Trợ giúp",
                icon: Icons.help,
                bgColor: Colors.red.shade100,
                iconColor: Colors.red,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Đăng xuất",
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

  void logout() {
    FirebaseAuth.instance.signOut();
    _goToLogIn(context);
  }

  _goToLogIn(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => const Login()));

  Future<String> getUserID() async {
    final User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      Fluttertoast.showToast(msg: 'login to continue');
      return "";
    }
  }

  Future<String> getUserEmail() async {
    final User? user = auth.currentUser;
    if (user != null) {
      return user.email.toString();
    } else {
      Fluttertoast.showToast(msg: 'login to continue');
      return "";
    }
  }

  Future<void> loadProfile() async {
    ref = FirebaseDatabase.instance.ref(idUser).child("Profile");
    if (ref == null) {
      Fluttertoast.showToast(msg: "Database reference is not initialized.");
      return;
    }
    final snapshot = await ref!.get();
    if (snapshot.exists) {
      setState(() {
        yourName = snapshot.child("Name").value.toString();
        imageAvatar = snapshot.child("Avatar").value.toString();
      });
    }
  }

  Future<void> loadId() async {
    String id = await getUserID();
    setState(() {
      idUser = id;
    });
  }
}

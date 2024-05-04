import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../Main_Function/EditItem.dart';
import 'EditAccountScreen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Map<dynamic, dynamic> profile = {};
  final FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference? ref;
  bool isLoading = true;
  String? idUser;
  String email = "";
  late String imageAvatar = "";
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_outlined)),
            leadingWidth: 80,
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditAccountScreen(),
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          fixedSize: const Size(60, 50),
                          elevation: 3),
                      icon: const Icon(Icons.edit, color: Colors.white)))
            ]),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 20, left: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Account",
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 40),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                imageAvatar.isNotEmpty
                                    ? SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipOval(
                                          child: Image.network(
                                            imageAvatar,
                                            fit: BoxFit
                                                .cover, // Cover the entire area
                                          ),
                                        ),
                                      )
                                    // Image.file(getImage!)
                                    : Image.asset("assets/images/avatar.png",
                                        height: 100, width: 100),
                              ]),
                          EditItem(
                              title: "Name",
                              widget: TextFormField(
                                controller: _nameController,
                                enabled: false,
                              )),
                          const SizedBox(height: 40),
                          EditItem(
                              title: "Gender",
                              widget: TextFormField(
                                controller: _genderController,
                                enabled: false,
                              )),
                          const SizedBox(height: 20),
                          EditItem(
                              widget: TextFormField(
                                controller: _ageController,
                                enabled: false,
                              ),
                              title: "Age"),
                          const SizedBox(height: 20),
                          EditItem(
                              widget: TextFormField(
                                controller: _emailController,
                                enabled: false,
                              ),
                              title: "Email"),
                          const SizedBox(height: 20),
                          EditItem(
                              widget: TextFormField(
                                controller: _phoneController,
                                enabled: false,
                              ),
                              title: "Phone")
                        ]))));
  }

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
    String emailUser = await getUserEmail();
    setState(() {
      email = emailUser;
      _emailController.text = email;
    });

    ref = FirebaseDatabase.instance.ref(idUser).child("Profile");
    if (ref == null) {
      Fluttertoast.showToast(msg: "Database reference is not initialized.");
      return;
    }
    final snapshot = await ref!.get();
    if (snapshot.exists) {
      setState(() {
        isLoading = false;
        // profile = snapshot.value as Map<dynamic, dynamic>;
        _nameController.text =
            snapshot.child('Name').value.toString().isNotEmpty
                ? snapshot.child('Name').value.toString()
                : "Edit Account to show";
        _ageController.text = snapshot.child("Age").value.toString();
        _genderController.text = snapshot.child("Gender").value.toString();
        _phoneController.text = snapshot.child("Phone").value.toString();
        imageAvatar = snapshot.child('Avatar').value.toString();
      });
    } else {
      Fluttertoast.showToast(msg: "No data found.");
    }
  }

  Future<void> loadId() async {
    String id = await getUserID();
    setState(() {
      idUser = id;
    });
  }
}

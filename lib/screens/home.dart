import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:my_doctor/FuncHomeScreen/Map.dart';
import 'package:my_doctor/FuncHomeScreen/abc.dart';
import 'package:my_doctor/screens/Medicine.dart';
import 'package:my_doctor/screens/Notification_Screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Main_Function/linhtinh.dart';
import 'BMI_screen.dart';
import 'calendarScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DatabaseReference? ref;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? idUser;
  String yourName = '';
  String email = "";

  List catNames = [
    'Đơn thuốc đã lưu',
    'Lịch dùng thuốc',
    'Quản lý nhắc nhở',
    'Tra cứu nhà thuốc',
    'Kiểm tra sức khoẻ',
  ];
  List imgData = [
    'assets/images/medicine.png',
    'assets/images/calender.png',
    'assets/images/noti.png',
    'assets/images/location.png',
    'assets/images/bmi.png',
  ];
  List<Icon> catIcon = const [
    Icon(Icons.category, color: Colors.blue, size: 50),
    Icon(Icons.video_library, color: Colors.redAccent, size: 50),
    Icon(Icons.assessment, color: Colors.redAccent, size: 50),
    Icon(Icons.store, color: Colors.redAccent, size: 50),
    Icon(Icons.store, color: Colors.redAccent, size: 50),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    await loadId();
    loadEmail();
    await loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
          ),
          backgroundColor: Colors.red,
          onPressed: (){
          launchUrl(Uri(scheme: 'tel',path: '115',));
          // FlutterPhoneDirectCaller.callNumber('114');
          },
          child: const Icon(Icons.call,color: Colors.white,),
        ),
        body: ListView(children: [
          Container(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, right: 15, left: 15),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.dashboard, color: Colors.white, size: 30),
                          Icon(
                              color: Colors.white,
                              Icons.notifications,
                              size: 30)
                        ]),

                    const SizedBox(height: 20),
                     Padding(
                        padding: const EdgeInsets.only(left: 3, bottom: 15),
                        child: Row(
                          children: [
                            const Text('Chào ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    wordSpacing: 2)),
                            Text(yourName.isEmpty?email:yourName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    wordSpacing: 2)),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Tìm kiếm... ",
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.3),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20),
                                prefixIcon:
                                    const Icon(Icons.search, size: 30))))
                  ])),
          Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Column(children: [
                GridView.builder(
                    itemCount: imgData.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 25,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          forwardCat(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10,right: 10,left: 10),
                          margin:
                              const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(imgData[index],
                              width: 90,),
                              const SizedBox(height: 10),
                              Expanded(
                                child:  Text(
                                    catNames[index],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),

                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ]))
        ]));
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
      });
    }
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
  void loadEmail() async{
    String emailUser = await getUserEmail();
    List<String> parts = emailUser.split('@');
    setState(() {
      email = parts[0];
    });
  }
  Future<void> loadId() async {
    String id = await getUserID();
    setState(() {
      idUser = id;
    });
  }
  void forwardCat(int key) {
    switch (key) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Medicine()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Calendar()));
        break;
        case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
        break;
        case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const map()));
        break;
        case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const BmiScreen()));
        break;
        case 5:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>  const Medicine()));
        break;
    }
  }
}

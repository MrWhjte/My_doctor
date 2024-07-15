import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Auth/Login.dart';
import '../Main_Function/notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Map<dynamic, dynamic> invoiceData = {};
  late List<Map<String, dynamic>> dataList = [];
  late List<String> dayList;
  final FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference? ref;
  DatabaseReference? ref1;
  late String idUser;
  String test = '';
  bool isLoad = true;
  bool isAlarm = true;
  bool checkData = true;
  bool status = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    await loadData();
    getHoaDon();
    getDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
      ),
      body: Container(
        color: Colors.blue.shade300,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              children: [
                const Text(
                  'Quản lý thông báo',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w700),
                ),
                isAlarm
                    ? Image.asset('assets/images/alarmOn.gif')
                    : Image.asset('assets/images/alarmOff.png'),
                checkData //false thì có // true thì chưa
                    ? const Text(
                        'Bạn chưa đặt thông báo nào',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      )
                    : Column(
                        children: [
                          const Text(
                            'Bạn đã đặt lịch nhắc nhở uống thuốc vào lúc',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          isLoad
                              ? const Center(child: CircularProgressIndicator())
                              : Text(
                                  getTime(dataList[0]['id']),
                                  style: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                        ],
                      ),
                const SizedBox(
                  height: 10,
                ),
                switchShow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTime(String id) {
    String time = '';
    getHoaDonById(id);
    if (invoiceData.isNotEmpty) {
      time = invoiceData['tagTime'];
    }
    time = time.replaceAll('[', '').replaceAll(']', '');
    return time;
  }

  Future<void> getHoaDonById(String id) async {
    ref = FirebaseDatabase.instance.ref(idUser).child("Invoices").child(id);
    if (ref == null) {
      Fluttertoast.showToast(msg: "Database reference is not initialized.");
      return;
    }
    final snapshot = await ref!.get();
    if (snapshot.exists) {
      setState(() {
        invoiceData = snapshot.value as Map<dynamic, dynamic>;
      });
    } else {
      Fluttertoast.showToast(msg: "No data found.");
    }
  }

  Future<void> getDay() async {
    DatabaseReference refDay =
        FirebaseDatabase.instance.ref(idUser).child('Day');
    refDay.onValue.listen((event) {
      var dayValue = event.snapshot.value;
      if (dayValue == null) {
        return; // Bỏ qua nếu giá trị là null
      }
      String dayStr = dayValue.toString();
      dayStr = dayStr.replaceAll('[', '').replaceAll(']', '');
      setState(() {
        dayList = dayStr.split(', ');
      });
    });
  }

  Future<void> getHoaDon() async {
    dataList.clear();
    ref = FirebaseDatabase.instance.ref(idUser).child("Invoices");
    if (ref == null) {
      Fluttertoast.showToast(msg: "Database reference is not initialized.");
      return;
    }
    ref?.onValue.listen((event) {
      for (var snapshot in event.snapshot.children) {
        dataList.add({
          'id': snapshot.key,
          'time': DateTime.parse(snapshot.child('timeUp').value.toString())
        });
      }
      _sortDataList(dataList);
      if (dataList.isEmpty) {
        setState(() {
          checkData = true;
          isLoad = true;
          status = false;
          isAlarm = false;
        });
      } else {
        setState(() {
          checkData = false;
          status = true;
          isLoad = false;
          isAlarm = true;
        });
      }
    });
  }

  Future<void> loadData() async {
    String id = await getUserID();
    setState(() {
      idUser = id;
    });
  }

  Future<String> getUserID() async {
    final User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      Fluttertoast.showToast(msg: 'Vui lòng đăng nhập để tiếp tục');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (Route<dynamic> route) => false);
      return Future.error('User not logged in');
    }
  }

  void _sortDataList(List<Map<String, dynamic>> dataListTemp) {
    dataListTemp.sort((a, b) => b["time"].compareTo(a["time"]));
  }

  Widget switchShow() {
    return FlutterSwitch(
      width: 200.0,
      height: 90.0,
      toggleSize: 60.0,
      value: status,
      borderRadius: 50.0,
      padding: 10.0,
      activeToggleColor: const Color(0xFF6E40C9),
      inactiveToggleColor: const Color(0xFF2F363D),
      activeSwitchBorder: Border.all(
        color: const Color(0xFF3C1E70),
        width: 6.0,
      ),
      inactiveSwitchBorder: Border.all(
        color: const Color(0xFFD1D5DA),
        width: 6.0,
      ),
      activeColor: const Color(0xFF271052),
      inactiveColor: Colors.white,
      activeIcon: const Icon(
        Icons.notifications,
        color: Color(0xFFF8E3A1),
      ),
      inactiveIcon: const Icon(
        Icons.notifications_off,
        color: Color(0xFFF8E3A1),
      ),
      onToggle: (val) {
        if (checkData) {
          Fluttertoast.showToast(msg: 'Bạn chưa có đặt thông báo nào');
          return;
        }
        setState(() {
          status = val;

          if (val) {
            Fluttertoast.showToast(msg: 'Đã bật thông báo');
            NotificationHelper.scheduleNotifications(
                dayList, invoiceData['tagTime']);
            setState(() {
              isAlarm = true;
            });
          } else {
            Fluttertoast.showToast(msg: 'Đã tắt thông báo');
            NotificationHelper.scheduleNotifications([], '');
            setState(() {
              isAlarm = false;
            });
          }
        });
      },
    );
  }
}

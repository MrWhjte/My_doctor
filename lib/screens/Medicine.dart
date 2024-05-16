import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../Auth/Login.dart';
import '../screens/ShowDetailMedicine.dart';
import 'NavigationMenu.dart';

class Medicine extends StatefulWidget {
  const Medicine({super.key});

  @override
  State<Medicine> createState() => _MedicineState();
}

class _MedicineState extends State<Medicine> {
  late List<Map<String, dynamic>> dataList = [];
  late var idUser = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final Map<dynamic, dynamic> invoiceData;
  DatabaseReference? dbRef;
  bool isLoadIdUser = true;
  late Map<dynamic, dynamic> invoice = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoadIdUser
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Your Medicine",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NavigationMenu(index: 2)));
                                },
                                child: const Icon(Icons.qr_code_scanner_sharp,
                                    size: 40, color: Colors.blue))
                          ]),
                      const SizedBox(height: 10),
                      Expanded(
                          child: FirebaseAnimatedList(
                              query: dbRef!,
                              itemBuilder:
                                  (context, snapshot, animation, index) {
                                return Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: card(dataList[index]["id"],
                                        dataList[index]["time"].toString()));
                              }))
                    ])));
  }

  Widget card(String id, String time) {
    DateTime dateTime = DateTime.parse(time);
    String formattedDateTime = DateFormat('dd-MM-yyy').format(dateTime);
    return Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowDetailMedicine(
                              idHoaDon: id, idUser: idUser.toString())));
                },
                child: Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 15, right: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Thông tin hoá đơn ngày $formattedDateTime",
                              style: const TextStyle(
                                  color: Colors.purple, fontSize: 20),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text("Mã hoá đơn #$id",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black)),
                          const Text('Bấm để xem thông tin chi tiết',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black))
                        ])))));
  }

  Future<void> loadData() async {
    String id = await getUserID();
    dbRef = FirebaseDatabase.instance.ref(id).child("Invoices");
    dbRef?.onValue.listen((event) {
      dataList.clear();
      for (var snapshot in event.snapshot.children) {
        dataList.add({
          'id': snapshot.key,
          'time': DateTime.parse(snapshot.child('timeUp').value.toString())
        });
      }
      _sortDataList(dataList);
      // setState(
      //     () {}); // Cập nhật giao diện người dùng sau khi dữ liệu đã được sắp xếp
    });
    if (id.isNotEmpty) {
      setState(() {
        dataList.clear();
        idUser = id;
        isLoadIdUser = false;
      });
    } else {
      Fluttertoast.showToast(msg: 'Lỗi xác thực vui lòng đăng nhập');
    }
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
}

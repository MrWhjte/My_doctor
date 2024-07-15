import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  bool checkIsNotData = true;
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
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NavigationMenu(index: 1)));
            },
            child: const Icon(Icons.qr_code_scanner_sharp)),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          title: const Text(
            "Đơn thuốc của bạn",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
          ),
        ),
        body: checkIsNotData
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Expanded(
                        flex: 1, child: Image.asset('assets/images/empty.png')),
                    const Expanded(
                        flex: 1,
                        child: Text(
                          'Đơn thuốc của bạn trống ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                             ),
                        )),
                  ],
                ),
              )
            : isLoadIdUser
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Expanded(
                              child: FirebaseAnimatedList(
                                  query: dbRef!,
                                  itemBuilder:
                                      (context, snapshot, animation, index) {
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: card(
                                            dataList[index]["id"],
                                            dataList[index]["time"]
                                                .toString()));
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
      if (dataList.isNotEmpty) {
        checkIsNotData = false;
      }
    });
    // có ID
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

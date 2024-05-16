import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ShowDetailMedicine extends StatefulWidget {
  final String idHoaDon;
  final String idUser;

  const ShowDetailMedicine(
      {super.key, required this.idHoaDon, required this.idUser});

  @override
  State<ShowDetailMedicine> createState() => _ShowDetailMedicineState();
}

class _ShowDetailMedicineState extends State<ShowDetailMedicine> {
  late Map<dynamic, dynamic> invoiceData = {};
  String? idUser;
  String lieu='';
  String timeUse='';
  String? idHoaDon;
  String time="";
  final FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference? ref;
  bool isLoadIdUser = false;
  List<Map<String, dynamic>> medicines = [];


  @override
  void initState() {
    super.initState();
    String idInvoices = widget.idHoaDon;
    String idU = widget.idUser;
    setState(() {
      idHoaDon = idInvoices;
      idUser = idU;
    });
    getHoaDonById();
  }

  @override
  Widget build(BuildContext context) {
    time = invoiceData['timeUp'];
    timeUse = invoiceData['TimeUse'];
    lieu = invoiceData['lieu'];
    lieu.isEmpty?"":lieu;
    DateTime dateTime = DateTime.parse(time);
    String formattedDateTime =
        DateFormat('dd-MM-yyyy – hh:mm a').format(dateTime);
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'Chi tiết đơn thuốc',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_outlined)),
            leadingWidth: 50,
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () {
                        ref?.remove();
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: 'delete is success');
                      },
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          fixedSize: const Size(55, 50),
                          elevation: 3
                      ),
                      icon: const Icon(Icons.delete, color: Colors.white)
                  )
              )
            ]
        ),

        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 15),
          child: Center(
            child: Column(
              children: [
                invoiceData.isNotEmpty ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Invoice ID: $idHoaDon",
                        style:
                        const TextStyle(color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),),
                      Text("Thời gian quét: $formattedDateTime",
                          style:
                          const TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20)),
                      Text("Thời gian sử dụng: $timeUse",
                          style:
                          const TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20)),
                      const Text("Số lượng thuốc đã ghi nhận",
                          style:
                          TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20)),
                       Text("Số lượng liều thuốc: $lieu",
                          style:
                          const TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20)),
                      Expanded(child: showText())
                    ],
                  ),
                ) : const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        )
    );
  }
  Widget showText() {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(
                              right: 5, top: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                    Expanded(
                                      child: Text(
                                          "${index + 1}. ${medicines[index]['name']}",
                                          style: const TextStyle(fontSize: 20)
                                      ),
                                    ),
                                InkWell(
                                    onTap: () {
                                      Fluttertoast.showToast(msg: "${medicines[index]} ");
                                    },
                                    child: const Icon(Icons.search)
                                )
                              ]
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30,top: 5),
                        child: Row(
                          children: [
                            const Text('Cách dùng : ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400)),
                            showUseAndTime(medicines[index]['use']),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30,top: 5),
                        child: Row(
                          children: [
                            const Text('Giờ uống : ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400)),
                            showUseAndTime(medicines[index]['time']),
                          ],
                        ),
                      ),
                    ],
                  );
                }
            )
        )
      ],
    );

  }
  Widget showUseAndTime(String list){
    String temp = list.replaceAll('[', '').replaceAll(']', '');
    return Expanded(
      child: Text(
        list.isNotEmpty
            ? temp
            : ' Không có',
          style:
          const TextStyle(color:  Color(0xf3ff6302),fontSize: 20),
      ),
    );
  }

  Future<void> getHoaDonById() async {
    ref = FirebaseDatabase.instance
        .ref(idUser)
        .child("Invoices")
        .child(idHoaDon!);
    if (ref == null) {
      Fluttertoast.showToast(msg: "Database reference is not initialized.");
      return;
    }
    final snapshot = await ref!.get();
    if (snapshot.exists) {
      setState(() {
        invoiceData = snapshot.value as Map<dynamic, dynamic>;
        medicines = parseMedicineList(invoiceData["name"]);
        debugPrint(medicines.toString());
      });
    } else {
      Fluttertoast.showToast(msg: "No data found.");
    }
  }

  // List<String> parseMedicineList(List<Object?> inputList) {
  //   List<String> validMedicines = [];
  //
  //   for (var item in inputList) {
  //     if (item != null && item is String && item.toLowerCase() != 'null') {
  //       validMedicines.add(item.trim());
  //     }
  //   }
  //   return validMedicines;
  // }
  List<Map<String, dynamic>> parseMedicineList(Map<dynamic, dynamic> inputMap) {
    List<Map<String, dynamic>> medicines = [];
    inputMap.forEach((key, value) {
      if (value is Map) {
        Map<String, dynamic> medicineDetails = {
          'name': key,
          'use': value['use'] ?? '',
          'time': value['timeUp'] ?? ''
        };
        medicines.add(medicineDetails);
      }
    });
    return medicines;
  }
}


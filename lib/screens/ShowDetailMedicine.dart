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
  String? idHoaDon;
  String time="";
  final FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference? ref;
  bool isLoadIdUser = false;
  List<String> medicines = [];

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
    time = invoiceData['time'];
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
                      Text("Thời gian: $formattedDateTime",
                          style:
                          const TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20)),
                      const Text("Số lượng thuốc đã ghi nhận",
                          style:
                          TextStyle(color: Colors.black,
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
    medicines = parseMedicineList(invoiceData["name"]);
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: medicines.length, // S? l??ng items trong danh sách
                itemBuilder: (context, index) {
                  return Container(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, top: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${index + 1}. ${medicines[index]}",
                                style: const TextStyle(fontSize: 20)
                            ),
                            InkWell(
                                onTap: () {
                                  Fluttertoast.showToast(msg: "${medicines[index]} ");
                                },
                                child: const Icon(Icons.search)
                            )
                          ]
                      )
                  );
                }
            )
        )
      ],
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
      });
    } else {
      Fluttertoast.showToast(msg: "No data found.");
    }
  }

  List<String> parseMedicineList(List<Object?> inputList) {
    List<String> validMedicines = [];

    for (var item in inputList) {
      if (item != null && item is String && item.toLowerCase() != 'null') {
        validMedicines.add(item.trim());
      }
    }
    return validMedicines;
  }
}


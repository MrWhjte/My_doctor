import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../Main_Function/ScansScreen.dart';
import '../screens/ShowDetailMedicine.dart';
import 'package:uuid/uuid.dart';

class Medicine extends StatefulWidget
{
    const Medicine({super.key});

    @override
    State<Medicine> createState() => _MedicineState();
}
class _MedicineState extends State<Medicine>
{
    late String idUser;
    final FirebaseAuth auth = FirebaseAuth.instance;
    late final Map<dynamic, dynamic> invoiceData;
     DatabaseReference? dbRef;
     bool isLoadIdUser = false;
    late Map<dynamic, dynamic> invoice={};

    @override
    void initState()
    {
        // TODO: implement initState
        super.initState();
        loadData();
    }

    @override
    Widget build(BuildContext context)
    {
        if (!isLoadIdUser) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
            );
        }
        return   
        Scaffold(
            body:
            Padding(
              padding: const EdgeInsets.only(top: 30.0,left: 20,right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          const Text(
                              "Your Medicine",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          InkWell(onTap: ()
                          {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => const ScansScreen()));
                          },
                              child: const Icon(Icons.qr_code_scanner_sharp,size: 40,color: Colors.blue))
                      ]
                  ),
                      const SizedBox(height: 10),
                      Expanded(
                          child: FirebaseAnimatedList(query: dbRef!,
                              itemBuilder: ( context, snapshot,
                                  animation,index)
                              {
                                  return
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: card(snapshot.child("id").value.toString()),
                                  );
                              }))
                  ]
              ),
            )
        );
    }
Widget card(String id){
    return Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 100,
            child: InkWell(
                onTap: ()
                {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  ShowDetailMedicine( idHoaDon: id, idUser: idUser)
                        )
                    );
                },
                child:  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15,right: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const Text(
                                "Thông tin hoá đơn của lachaixon@gmail.com",
                                style: TextStyle(color: Colors.purple, fontSize: 20),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis
                            ),
                            Text("Mã hoá đơn #$id",style: const TextStyle(fontSize:15,color: Colors.black )),
                            const Text('Bấm để xem thông tin chi tiết',style: TextStyle(fontSize:15,color: Colors.black ))
                        ]
                    )
                )
            )
        )
    );
}
    Future<void> loadData() async {
        String id = await getUserID();
        dbRef = FirebaseDatabase.instance.ref(id).child("Invoices");
        if (id.isNotEmpty) {
            setState(() {
                idUser = id;
                isLoadIdUser = true;
            });
        }else{
            Fluttertoast.showToast(msg: 'Lỗi xác thực vui lòng đăng nhập lại');
        }
    }

    Future<String> getUserID() async
    {
        final User? user = auth.currentUser;
        if (user != null)
        {
            return user.uid;
        } else
        {
            Fluttertoast.showToast(msg: 'login to continue');
            return "";

        }
    }
}

import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_doctor/Auth/Login.dart';
import 'helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ScansScreen extends StatefulWidget
{
    const ScansScreen({super.key});

    @override
    State<ScansScreen> createState() => _ScansScreenState();
}

class _ScansScreenState extends State<ScansScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> _listNameProduct = [];
  File? getImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              onPressed: () {
                _getImagesCamera();
              },
              child: const Icon(Icons.camera))
        ]),
        body: Container(
            padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
            child: Column(children: [
              Container(
                  height: 70,
                  padding: const EdgeInsets.all(5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Scan prescriptions',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w700)),
                        InkWell(
                            onTap: () {
                              _upLoadData(_listNameProduct);
                            },
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                    color: Colors.lightBlueAccent,
                                    shape: BoxShape.circle),
                                child: const Center(
                                    child: Icon(Icons.check,
                                        size: 30, color: Colors.white))))
                      ])),
              Container(
                  padding: const EdgeInsets.only(
                      top: 5, right: 10, left: 10, bottom: 5),
                  child: Card(
                      color: Colors.grey,
                      margin: const EdgeInsets.all(10),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: InkWell(
                              onTap: () {
                                _getImages();
                              },
                              child: getImage != null
                                  ? Image.file(getImage!)
                                  : const Icon(Icons.add,
                                      size: 50, color: Colors.white))))),
              const SizedBox(height: 20),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      height: MediaQuery.of(context).size.height - 400,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(children: [
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Invoice information',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25))
                            ]),
                        _extractTextView()
                      ])))
            ])));
  }

  Widget _extractTextView() {
    if (getImage == null)
    {
      return const Text('',style: TextStyle(color: Colors.red,fontSize: 20));
    }
    return FutureBuilder(
        future: _extractText(getImage!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                margin: const EdgeInsets.all(15),
                child: const Center(
                    child: CircularProgressIndicator(color: Colors.blue)));
          } else {
            String result = snapshot.data ?? "";
            String nameUser = Helper().getNameUser(result);
            List<String> listNameProduct = Helper().getListNameProduct(result);
            _listNameProduct = listNameProduct;
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  Expanded(
                      child: Column(children: [
                    Row(children: [
                      const Text("Tên khách hàng: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 20)),
                      Text(nameUser,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20))
                    ]),
                    const SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Danh sách thuocc: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20)),
                          InkWell(
                              onTap: () {},
                              child: const Icon(Icons.add_circle_outline,
                                  size: 30, color: Colors.black))
                        ]),
                    const SizedBox(height: 15),
                    Expanded(
                        child: ListView.builder(
                            itemCount: listNameProduct.length,
                            // S? l??ng items trong danh sách
                            itemBuilder: (context, index) {
                              return Container(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15, top: 5),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "${index + 1}. ${listNameProduct[index]}",
                                            style:
                                                const TextStyle(fontSize: 20)),
                                        InkWell(
                                            onTap: () {},
                                            child: const Icon(Icons.edit))
                                      ]));
                            }))
                  ]))
                ]));
          }
        });
  }

  Future<String?> _extractText(File file) async {
    final textRecognized = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognized.processImage(inputImage);
    String text = recognizedText.text;
    textRecognized.close();
    return text;
  }

  Future _getImages() async
  {
    var getimg = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(()
    {
      getImage = File(getimg!.path);
    });
  }

  Future _getImagesCamera() async {
    var getimg = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      getImage = File(getimg!.path);
    });
  }

  Widget setText(String text, {Color? color, double? fontSize}) {
    return Text(text,
        style: TextStyle(color: Colors.black, fontSize: fontSize));
  }

  Future<void> _upLoadData(List<String> medicineList) async {
    if (medicineList.isEmpty) {
      Fluttertoast.showToast(msg: 'Data is empty');
      return;
    }
    String idUser = await getUserID();
    String emailUser = await getUserEmail();
    if (idUser.isEmpty || emailUser.isEmpty) {
      Fluttertoast.showToast(msg: 'Have error');
    }
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref(idUser);
    var invoiceRef = databaseReference.child("Invoices");
    var time = DateTime.now().toString();
    var id = generateIdWithPrefix(5);
    Map<String, dynamic> invoiceData = {
      'id': id,
      'time': time,
      'name': {},
    };
    for (int i = 0; i < medicineList.length; i++) {
      invoiceData['name']['${i + 1}'] = medicineList[i];
    }
    await invoiceRef.child(id).set(invoiceData);
    Fluttertoast.showToast(msg: 'Add success!');
    setState(() {
      getImage = null;
    });
  }

  Future<String> getUserID() async {
    final User? user = auth.currentUser;
    if (user == null) {
      Fluttertoast.showToast(msg: 'Please log in to continue');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
      return "";
    }
    return user.uid;
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

  String generateIdWithPrefix(int length) {
    Random random = Random();
    String id = '';
    for (int i = 0; i < length; i++) {
      id += random.nextInt(10).toString();
    }
    return id;
  }
}

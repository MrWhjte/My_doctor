import 'dart:io';
import 'dart:math';
import 'package:chips_choice/chips_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_doctor/Auth/Login.dart';
import '../screens/GetTime.dart';
import 'helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ScansScreen extends StatefulWidget {
  const ScansScreen({super.key});

  @override
  State<ScansScreen> createState() => _ScansScreenState();
}

class _ScansScreenState extends State<ScansScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> _listNameProduct = [];
  List<TextEditingController> _controllers = [];
  TextEditingController usageController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String nameUser = "";
  List<String> _usageList = [];
  List<String> _timeList = [];
  String lieuThuoc = "";
  bool notification = false;
  String tagTime = '';
  String tagSession = '';
  List<String> options = [
    'News',
    'Entertainment',
    'Politics',
    'Automotive',
    'Sports',
    'Education',
    'Fashion',
    'Travel',
    'Food',
    'Tech',
    'Science',
  ];
  File? getImage;
  File? currentGetImage;
  bool checkArrow = false;
  bool checkImage = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
        _listNameProduct.length, (index) => TextEditingController());
    _usageList = List.generate(_listNameProduct.length, (index) => '');
    _timeList = List.generate(_listNameProduct.length, (index) => '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              onPressed: () {
                _getImagesCamera();
              },
              child: const Icon(Icons.camera))
        ]),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(top: 20, right: 5, left: 5),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
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
                Container(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    height: MediaQuery.of(context).size.height - 400,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Invoice information',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25))
                          ]),
                      checkImage
                          ? _extractTextView()
                          : Text(
                              'Chọn hoá đơn để quét',
                              style: TextStyle(
                                  color: Colors.grey.withOpacity(0.7),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                    ])))
              ])),
        ));
  }

  Widget _extractTextView() {
    var check = notification
        ? const Text('Có', style: TextStyle(color: Colors.lightGreenAccent))
        : const Text('Không', style: TextStyle(color: Colors.redAccent));
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
                  style: const TextStyle(color: Colors.black, fontSize: 20))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Danh sách thuốc: ",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20)),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        _addNewProduct();
                      },
                      child: const Icon(Icons.add_circle_outline,
                          size: 30, color: Colors.green)),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        _showBottomSheet(context);
                      },
                      child: const Icon(Icons.alarm,
                          size: 30, color: Colors.green))
                ],
              )
            ]),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Số liều thuốc: $lieuThuoc",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20)),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  text: 'Thông báo nhắc nhở: ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: notification ? "có" : "không",
                      style: TextStyle(
                          color: notification ? Colors.green : Colors.red,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: _listNameProduct.length,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _controllers[index],
                                        decoration: InputDecoration(
                                          labelText: "Thuốc ${index + 1}",
                                          border: InputBorder.none,
                                          labelStyle: const TextStyle(
                                              color: Colors.purple,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                        maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                        onChanged: (value) {
                                          _listNameProduct[index] = value;
                                        },
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _removeProduct(index);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _showInputDialog(index);
                                      },
                                      child:  Icon(
                                        Icons.add_circle_outline,
                                        color: _usageList[index].isNotEmpty
                                            ? Colors.green
                                            : Colors.grey,
                                        size: 25,
                                      ),
                                    ),
                                  ]),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    const Text('Cách dùng :',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    Text(
                                      _usageList[index].isNotEmpty
                                          ? _usageList[index]
                                          : ' Không có',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    const Text('Giờ uống :',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    Text(
                                      _timeList[index].isNotEmpty
                                          ? _timeList[index]
                                          : ' Không có',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    })),
          ])),
        ]));
  }

  void _showBottomSheet(BuildContext context) async {
    final selectedTags = await showModalBottomSheet<Map<String, List<String>>>(
      context: context,
      backgroundColor: Colors.grey,
      isDismissible: false,
      builder: (context) => const Schedule(),
    );
    if (selectedTags != null) {
      List<String>? tags1 = selectedTags['tagSession'];
      List<String>? tags2 = selectedTags['tagTime'];
      setState(() {
        if (tags2!.isEmpty || tags1!.isEmpty) {
          notification = false;
          tagTime = 'không có';
          tagSession = 'Không có';
        } else {
          notification = true;
          tagTime = tags2.toString();
          tagSession = tags1.toString();
        }
      });
    }
  }

  void _addNewProduct() {
    setState(() {
      int newIndex =
          _listNameProduct.length + 1; // Incremented index for the new product
      _listNameProduct.add("Product $newIndex"); // Add new product
      _controllers.add(TextEditingController()); // Add new controller
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _listNameProduct.removeAt(index);
      _usageList.removeAt(index);
      _timeList.removeAt(index);
      _controllers.removeAt(index);
    });
    Fluttertoast.showToast(msg: "Đã xóa");
  }

  void _showInputDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nhập thông tin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: usageController,
                decoration: const InputDecoration(labelText: 'Cách dùng/số lượng'),
              ),
              TextFormField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Buổi uống'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _usageList[index] = usageController.text;
                  _timeList[index] = timeController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  _extractText(File file) async {
    final textRecognized = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognized.processImage(inputImage);
    String text = recognizedText.text;
    textRecognized.close();
    // debugPrint(text);
    String lieuThuocx = Helper().getLieuThuoc(text);
    String name = Helper().getNameUser(text);
    List<String> listNameProduct = Helper().getListNameProduct(text);
    setState(() {
      lieuThuoc = lieuThuocx;
      nameUser = name;
      _listNameProduct = listNameProduct;
      _usageList = List.generate(_listNameProduct.length, (index) => '');
      _timeList = List.generate(_listNameProduct.length, (index) => '');
      _controllers = _listNameProduct
          .map((product) => TextEditingController(text: product))
          .toList();
      checkImage = true;
    });
  }

  Future _getImages() async {
    var getimg = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (getimg != null) {
      File imageFile = File(getimg.path);
      setState(() {
        getImage = imageFile;
      });
      _extractText(imageFile);
    } else {
      setState(() {
        getImage = null;
      });
      Fluttertoast.showToast(msg: 'No image selected.');
    }
  }

  Future _getImagesCamera() async {
    var getimg = await ImagePicker().pickImage(source: ImageSource.camera);
    if (getimg != null) {
      File imageFile = File(getimg.path);
      setState(() {
        getImage = imageFile;
      });
      _extractText(imageFile);
    } else {
      setState(() {
        getImage = null;
      });
      Fluttertoast.showToast(msg: 'No image captured.');
    }
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
    var num = lieuThuoc == '0' ? 0 : lieuThuoc;

    Map<String, dynamic> invoiceData = {
      'tagTime': tagTime,
      'tagSession': tagSession,
      'id': id,
      'time': time,
      'name': {},
      'lieu': num
    };

    // for (int i = 0; i < medicineList.length; i++) {
    //   invoiceData['name']['${i + 1}'] = medicineList[i];
    // }
    for (int i = 0; i < medicineList.length; i++) {
      invoiceData['name'][medicineList[i]] = {
        'use': _usageList[i],
        'time': _timeList[i]
      };
    }

    await invoiceRef.child(id).set(invoiceData);
    Fluttertoast.showToast(msg: 'Add success!');
    setState(() {
      notification = false;
      lieuThuoc = " ";
      getImage = null;
      _listNameProduct = [];
      nameUser = "";
    });
    List<String> items = tagSession.split(', ');
    int count = items.length;
    await _upLoadDay(num.toString(), count, idUser);
  }

  _upLoadDay(String numStr, int tagSession, String id) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref(id);
    var invoiceRef = databaseReference.child("Day");

    double number = double.parse(numStr);
    int num = number ~/ tagSession;
    if (num % tagSession != 0) {
      num += 1;
    }
    List<String> days = [];
    DateTime today = DateTime.now();
    for (int i = 0; i < num; i++) {
      DateTime nextDay = today.add(Duration(days: i));
      days.add(nextDay.day.toString());
    }
    invoiceRef.set(days.toString());
    // Fluttertoast.showToast(msg:" ${days.toString()}");
    // debugPrint(days.toString());
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

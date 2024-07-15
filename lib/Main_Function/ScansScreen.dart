import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_doctor/Auth/Login.dart';
import '../screens/GetInformationOnEachName.dart';
import '../screens/GetTime.dart';
import 'helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'notifications.dart';

class ScansScreen extends StatefulWidget {
  const ScansScreen({super.key});

  @override
  State<ScansScreen> createState() => _ScansScreenState();
}

class _ScansScreenState extends State<ScansScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> _listNameProduct = [];
  List<TextEditingController> _controllers = [];
  final TextEditingController _noteController = TextEditingController();
  TextEditingController numLieuChangeController = TextEditingController();
  String nameUser = "";
  List<String> _usageList = [];
  List<String> _timeList = [];
  late String getTimeFromCalenderUp;
  late String getTimeFromCalender;
  String lieuThuoc = "";
  bool notification = false;
  bool notificationOnName = false;
  String tagTime = '';
  bool _isVisible = true;
  String tagSession = '';
  String numLieuChange = '';
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
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _getImagesCamera();
            },
            child: const Icon(Icons.camera)),
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
                          const Text('Quét Hoá Đơn',
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
                    padding: const EdgeInsets.only( right: 10, left: 10),
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
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    height: MediaQuery.of(context).size.height - 400,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Thông tin đơn thuốc',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25))
                          ]),
                      checkImage
                          ? _extractTextView()
                          : getImage != null
                              ? Center(
                                  child: SizedBox(
                                    width: 200,
                                      height: 200,
                                      child: Image.asset(
                                          'assets/images/scan.gif')),
                                )
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  const Text(
                    "Tên khách hàng: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    nameUser,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Số liều thuốc: ${lieuThuoc}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  InkWell(
                    child: const Text(
                      'Thay đổi',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      numLieuChangeController.text = '';
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: Colors.white,
                        isDismissible: false,
                        builder: (BuildContext context) {
                          return Wrap(children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 18),
                              child: Center(
                                child: Text(
                                  "Nhập số liều ",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(25),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: TextField(
                                  controller: numLieuChangeController,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (mounted) {
                                          setState(() {
                                            lieuThuoc = numLieuChangeController
                                                    .text.isEmpty
                                                ? '0'
                                                : numLieuChangeController.text;
                                          });
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          shadowColor:
                                              Colors.black.withOpacity(0.5),
                                          elevation: 20),
                                      child: const Text('Đồng ý',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20))),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (mounted) {
                                          setState(() {
                                            Navigator.of(context).pop();
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          shadowColor:
                                              Colors.black.withOpacity(0.5),
                                          elevation: 20),
                                      child: const Text('Thoát',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20))),
                                ),
                              ],
                            ),
                          ]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Align(
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
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
               Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Danh sách thuốc: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _addNewProduct();
                          },
                          child: const Icon(
                            Icons.add_circle_outline,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            _showBottomSheet(context);
                          },
                          child: Icon(
                            Icons.alarm,
                            size: 30,
                            color: tagSession.isNotEmpty || tagSession.isNotEmpty
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _listNameProduct.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(right: 11, left: 11),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _controllers[index],
                              decoration: InputDecoration(
                                hintText: 'Nhập tên thuốc',
                                labelText: "Thuốc ${index + 1}",
                                border: InputBorder.none,
                                labelStyle: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
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
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              _showBottomSheetOnName(context, index);
                            },
                            child: Icon(
                              Icons.alarm_add_rounded,
                              color: _usageList[index].isNotEmpty
                                  ? Colors.green
                                  : Colors.grey,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            const Text(
                              'Buổi uống : ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            showUseAndTime(_timeList[index]),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            const Text(
                              'Cách dùng : ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            showUseAndTime(_usageList[index]),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Visibility(
              visible: _isVisible,
              child: const Padding(
                padding: EdgeInsets.all(0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Ghi chú",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isVisible,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 5, left: 5),
                child: TextFormField(
                  controller: _noteController,
                  maxLines: null, // Cho phép ghi chú nhiều dòng
                  decoration: InputDecoration(
                    hintText: 'Nhập nội dung ghi chú ở đây...',
                    border: OutlineInputBorder(), // Tạo viền cho TextFormField
                    filled: true, // Làm cho TextFormField có màu nền
                    fillColor: Colors.grey[200], // Màu nền
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showUseAndTime(String list) {
    String temp = list.replaceAll('[', '').replaceAll(']', '');
    return Text(
      list.isNotEmpty ? temp : ' Không có',
      style: const TextStyle(color: Colors.black),
    );
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
      List<String>? time = selectedTags['timeStartUse'];
      if (mounted) {
        setState(() {
          notification = true;
          tagTime = tags2.toString();
          tagSession = tags1.toString();
          getTimeFromCalender = time.toString();
          _timeList = List.generate(
              _listNameProduct.length, (index) => tags1.toString());
        });
      }
    }
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _showBottomSheetOnName(BuildContext context, int index) async {
    final selectedTags = await showModalBottomSheet<Map<String, List<String>>>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.grey,
      isDismissible: false,
      builder: (context) => const GetInformationOnEachName(),
    );
    if (selectedTags != null) {
      List<String>? tags1 = selectedTags['tagSessionOnName'];
      List<String>? tags2 = selectedTags['tagUse'];
      if (mounted) {
        setState(() {
          tags1!.isEmpty
              ? _timeList[index]
              : _timeList[index] = tags1.toString();
          tags2!.isEmpty
              ? _usageList[index] = 'không có'
              : _usageList[index] = tags2.toString();
        });
      }
    }
  }

  void _addNewProduct() {
    if (mounted) {
      setState(() {
        int newIndex = _listNameProduct.length + 1;
        _listNameProduct.add("Product $newIndex"); // Add new product
        _usageList.add('không có');
        _timeList.add('không có');
        _controllers.add(TextEditingController()); // Add new controller
      });
    }
  }

  void _removeProduct(int index) {
    if (mounted) {
      setState(() {
        _listNameProduct.removeAt(index);
        _usageList.removeAt(index);
        _timeList.removeAt(index);
        _controllers.removeAt(index);
      });
    }
    Fluttertoast.showToast(msg: "Đã xóa");
  }

  _extractText(File file) async {
    final textRecognized = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognized.processImage(inputImage);
    String text = recognizedText.text;
    textRecognized.close();

    String lieuThuocx = Helper().getLieuThuoc(text);
    String name = Helper().getNameUser(text);
    if(name=='null'){
      name = "Không có";
    }
    List<String> listNameProduct = Helper().getListNameProduct(text);
    if (mounted) {
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
  }

  Future _getImages() async {
    var getimg = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (getimg != null) {
      File imageFile = File(getimg.path);
      if (mounted) {
        setState(() {
          getImage = imageFile;
        });
      }
      _extractText(imageFile);
    } else {
      if (mounted) {
        setState(() {
          getImage = null;
        });
      }
      Fluttertoast.showToast(msg: 'Không có ảnh được chọn.');
    }
  }

  Future _getImagesCamera() async {
    var getimg = await ImagePicker().pickImage(source: ImageSource.camera);
    if (getimg != null) {
      File imageFile = File(getimg.path);
      if (mounted) {
        setState(() {
          getImage = imageFile;
        });
      }
      _extractText(imageFile);
    } else {
      if (mounted) {
        setState(() {
          getImage = null;
        });
      }
      Fluttertoast.showToast(msg: 'No image captured.');
    }
  }

  Widget setText(String text, {Color? color, double? fontSize}) {
    return Text(text,
        style: TextStyle(color: Colors.black, fontSize: fontSize));
  }

  /// tải data lên fb
  Future<void> _upLoadData(List<String> medicineList) async {
    if (medicineList.isEmpty) {
      if (mounted) {
        Fluttertoast.showToast(msg: 'Dữ liệu trống');
      }
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset('assets/images/load_2.gif'),
                ),
                const SizedBox(width: 20),
                const Text(
                  "Đang lưu dữ liệu...",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
try{
    String idUser = await getUserID();
    String emailUser = await getUserEmail();
    if (idUser.isEmpty || emailUser.isEmpty) {
      Fluttertoast.showToast(msg: 'Have error');
    }
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref(idUser);
    var invoiceRef = databaseReference.child("Invoices");
    var time = DateTime.now().toString();
    var id = generateIdWithPrefix(5);
    var soLieuThuoc = lieuThuoc == '0' ? '3' : lieuThuoc.toString();

    getTimeFromCalenderUp =
        getTimeFromCalender.replaceAll('[', '').replaceAll(']', '');

    String imageUrl = "";
    if (getImage != null) {
      imageUrl = await uploadImageToFirebaseStorage(getImage!,id);
      if (imageUrl.isEmpty) {
        Fluttertoast.showToast(msg: 'Đã xảy ra lỗi trong quá trình lưu ảnh vui lòng thử lại');
        return;
      }
    }

    Map<String, dynamic> invoiceData = {
      'tagTime': tagTime,
      'tagSession': tagSession,
      'id': id,
      'timeUp': time,
      'name': {},
      'lieu': soLieuThuoc,
      'TimeUse':getTimeFromCalenderUp,
      'Note' :_noteController.text.isEmpty?'Không có':_noteController.text,
      'invoiceImage':imageUrl,
    };

    for (int i = 0; i < medicineList.length; i++) {
      invoiceData['name']
          [medicineList[i]] = {'use': _usageList[i], 'time': _timeList[i]};
    }
    await invoiceRef.child(id).set(invoiceData);

    List<String> soLuongBuoiUong = tagSession.split(',');
    int count = soLuongBuoiUong.length;

    await _upLoadDay(soLieuThuoc.toString(), count, idUser);
    if (mounted) {
      _toggleVisibility();
      setState(() {
        notification = false;
        lieuThuoc = " ";
        getImage = null;
        _listNameProduct = [];
        nameUser = "";
      });
    }
    Fluttertoast.showToast(msg: 'Thành công');
  } finally{
  Navigator.of(context).pop();
  }
  }

//            solieuthuoc    sobuoiuong        idus
  _upLoadDay(String numStr, int tagSession, String id) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref(id);
    var invoiceRef = databaseReference.child("Day");
    var invoiceRefDayMonth = databaseReference.child("DayMonth");

    double number = double.parse(numStr);
    int num = (number / tagSession)
        .ceil(); // tính số ngày dựa trên số liều và số buổi
    List<String> days = [];
    List<String> dayMonth = [];
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    getTimeFromCalender =
        getTimeFromCalender.replaceAll('[', '').replaceAll(']', '');
    DateTime selectTime = DateTime.parse(getTimeFromCalender);

    for (int i = 0; i < num; i++) {
      if (today == selectTime) {
        DateTime nextDay = today.add(Duration(days: i));
        days.add(nextDay.day.toString());
        dayMonth.add(
            "${nextDay.day.toString().padLeft(2, '0')}/${nextDay.month.toString().padLeft(2, '0')}");
      } else {
        DateTime nextDay = selectTime.add(Duration(days: i));
        days.add(nextDay.day.toString());
        dayMonth.add(
            "${nextDay.day.toString().padLeft(2, '0')}/${nextDay.month.toString().padLeft(2, '0')}");
      }
    }
    await invoiceRef.set(days.toString());
    await invoiceRefDayMonth.set(dayMonth.toString());
    NotificationHelper.scheduleNotifications(days, tagTime);
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

  Future<String> uploadImageToFirebaseStorage(File imageFile, String id) async {
    String idUser = await getUserID();
    if (idUser.isEmpty) {
      Fluttertoast.showToast(msg: 'Have error');
    }
    final userProfileImageRef = FirebaseStorage.instance
        .ref(idUser)
        .child('InvoiceImage')
        .child('$id.jpg');
    await userProfileImageRef.putFile(imageFile);
    final imageUrl = await userProfileImageRef.getDownloadURL();
    return imageUrl;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    numLieuChangeController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}

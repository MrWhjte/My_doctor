import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class map extends StatefulWidget {
  const map({super.key});

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
  late List<Map<String, dynamic>> dataListLocal = [];
  DatabaseReference? dbRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    await loadData();
  }

  String? selectedProvince;
  String? selectedDistrict;

  List<String> provinces = [];
  List<String> district = [];
  List<dynamic> dataJson = [];
  late String resPro;

  late String resDis;

  int? selectedProvinceCode;

  Future<void> loadData() async {
    resDis = await rootBundle.loadString('assets/districtData.json');
    readJsonProvinces();
  }

  Future<void> readJsonProvinces() async {
    resPro = await rootBundle.loadString(('assets/provinceData.json'));
    final data = await json.decode(resPro) as List;
    setState(() {
      dataJson = data;
      provinces = data.map((item) => item['name'] as String).toList();
    });
  }

  int findCodeByName(String name) {
    for (var province in dataJson) {
      if (province['name'] == name) {
        if (province['code'] is String) {
          return province['code'];
        } else if (province['code'] is int) {
          return province['code']; // Trả về mã nếu nó đã là int
        }
      }
    }
    return 0;
  }

  Future<void> readJsonDistrict() async {
    final data = json.decode(resDis) as List;
    if (selectedProvinceCode != null) {
      // Lọc dữ liệu theo tỉnh mới
      final filteredDistricts = data
          .where(
              (district) => district['province_code'] == selectedProvinceCode)
          .toList();

      // Gán trực tiếp danh sách được lọc cho "district"
      district =
          filteredDistricts.map((item) => item['name'] as String).toList();
      for (String district in district) {
        // debugPrint(" \"${district.toString()}\": [],");
      }
    }
  }

  void updateProvinceAndFilterDistricts(int newProvinceCode) {
    setState(() {
      selectedProvinceCode = newProvinceCode;
      selectedDistrict = null;
    });
    readJsonDistrict();
  }

  List<String> tabs = [
    "Tìm kiếm nhà thuốc",
    "Nhà thuốc gần bạn",
  ];
  int current = 0;

  double changePositionedOfLine() {
    switch (current) {
      case 0:
        return 0;
      case 1:
        return 220;
      default:
        return 0;
    }
  }

  double changeContainerWidth() {
    switch (current) {
      case 0:
        return 220;
      case 1:
        return 220;
      default:
        return 0;
    }
  }

  Widget tabContent() {
    switch (current) {
      case 0:
        return find();
      case 1:
        return near();
      default:
        return const Text('Tab khan xác định');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tra cứu thông tin nhà thuốc"),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              width: size.width,
              height: size.height * 0.05,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: size.width,
                      height: size.height * 0.04,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: tabs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 20 : 90, top: 7),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    current = index;
                                  });
                                },
                                child: Text(
                                  tabs[index],
                                  style: TextStyle(
                                    fontSize: current == index ? 16 : 16,
                                    fontWeight: current == index
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  AnimatedPositioned(
                    curve: Curves.fastLinearToSlowEaseIn,
                    bottom: 0,
                    left: changePositionedOfLine(),
                    duration: const Duration(milliseconds: 500),
                    child: AnimatedContainer(
                      width: changeContainerWidth(),
                      height: size.height * 0.005,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.fastLinearToSlowEaseIn,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: tabContent(),
            )
          ],
        ),
      ),
    );
  }

  Widget LoadLocation(String location) {
    return Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 90,
            child: InkWell(
                onTap: () {
                  Fluttertoast.showToast(msg: location);
                },
                child: Padding(
                    padding:
                        const EdgeInsets.only(top: 25, left: 25, right: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(location,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ])))));
  }

  Widget find() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, top: 15),
          child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 20),
              width: MediaQuery.of(context).size.width,
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "Tìm theo tỉnh thành",
                    hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                    prefixIcon: const Icon(Icons.search, size: 30),
                    contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                    alignLabelWithHint: true,
                  ))),
        ),
        Row(
          children: [
            Container(
              height: 30,
              width: 190,
              child: const Divider(
                color: Colors.black,
                height: 20,
                thickness: 0.5,
                indent: 30,
                endIndent: 5,
              ),
            ),
            Container(
              child: Text("Hoặc"),
            ),
            Container(
              height: 30,
              width: 190,
              child: const Divider(
                color: Colors.black,
                height: 20,
                thickness: 0.5,
                indent: 5,
                endIndent: 20,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Chọn tỉnh, TP',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                ),
                value: selectedProvince,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedProvince = newValue;
                    updateProvinceAndFilterDistricts(
                        findCodeByName(newValue.toString()));
                  });
                },
                items: provinces.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                itemHeight: 48,
                menuMaxHeight: 300,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Chọn quận, huyện',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                ),
                value: selectedDistrict,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDistrict = newValue;
                    getLoadLocation(
                        province: selectedProvince, district: selectedDistrict);
                  });
                },
                items: district.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    key: ValueKey(value),
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                itemHeight: 48,
                menuMaxHeight: 300,
              ),
            ],
          ),
        ),
        Expanded(
          child: dbRef == null || selectedDistrict == null
              ? const Center(
                  child: Text(
                    "Chọn địa chỉ để hiện thị vị trí",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                )
              : dataListLocal.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Xin lỗi hiện tại không có nhà thuốc ở địa điểm này",
                          style: TextStyle(color: Colors.red, fontSize: 23),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : FirebaseAnimatedList(
                      query: dbRef!,
                      itemBuilder: (context, snapshot, animation, index) {
                        // Bây giờ không cần kiểm tra dbRef nữa, chỉ kiểm tra dataListLocal
                        return Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child:
                                LoadLocation(dataListLocal[index]['location']));
                      }),
        )
      ],
    );
  }

  Widget near() {
    return Center(
      child: Container(
        child: Row(
          children: [
            Container(
              height: 30,
              width: 190,
              child: const Divider(
                color: Colors.black,
                height: 20,
                thickness: 1,
                indent: 10,
                endIndent: 5,
              ),
            ),
            Container(
              child: Text("Hoặc"),
            ),
            Container(
              height: 30,
              width: 190,
              child: const Divider(
                color: Colors.black,
                height: 20,
                thickness: 1,
                indent: 10,
                endIndent: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getLoadLocation({required String? province, required String? district}) {
    dbRef = FirebaseDatabase.instance
        .ref("Location")
        .child(province!)
        .child(district!);
    dataListLocal.clear();
    dbRef?.onValue.listen((event) {
      for (var snapshot in event.snapshot.children) {
        dataListLocal.add({"location": snapshot.value});
      }
    });
  }
}

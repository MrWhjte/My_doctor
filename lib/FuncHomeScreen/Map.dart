import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart' as LocationPlugin;
import 'package:geocoding/geocoding.dart' as GeocodingPlugin;

import 'package:url_launcher/url_launcher.dart';

class map extends StatefulWidget {
  const map({super.key});

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
  late List<Map<String, dynamic>> dataListLocal = [];
  late List<Map<String, dynamic>> dataListGps = [];
  DatabaseReference? dbRef;
  bool isLoading = false;
  bool isLoadingGps = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
    _getCurrentLocation();
  }

  Future<void> initAsync() async {
    await loadData();
  }

  LocationPlugin.LocationData? _currentPosition;
  String _currentAddress = '';
  LocationPlugin.Location location = LocationPlugin.Location();

  String? selectedProvince;
  String? selectedDistrict;
  String currentLocationUser = "Press the button to get the location";
  bool isLoadMap = false;

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
        return findLocations();
      case 1:
        return getLocationFromGPS();
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
                                  left: index == 0 ? 20 : 80, top: 7),
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

  Widget loadLocation(String location) {
    return Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 90,
            child: InkWell(
                onTap: () async {
                  final encodedLocation = Uri.encodeComponent(location);
                  final googleMapsUrl =
                      'comgooglemaps://?center=$encodedLocation&zoom=14';
                  if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                    await launchUrl(Uri.parse(googleMapsUrl));
                    return; // Exit the onTap function if Google Maps opens
                  }
                  // Fallback to web map if Google Maps app is unavailable
                  final webMapUrl =
                      'https://www.google.com/maps/search/?api=1&query=$encodedLocation';
                  await launchUrl(Uri.parse(webMapUrl));
                },
                child: Padding(
                    padding:
                        const EdgeInsets.only(top: 25, left: 25, right: 30),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(location,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ])))));
  }

  Widget findLocations() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
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
          child: isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Hiển thị spinner khi đang tải
              : dbRef == null || selectedDistrict == null
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
                                child: loadLocation(
                                    dataListLocal[index]['location']));
                          }),
        )
      ],
    );
  }

  Future<void> getLoadLocation(
      {required String? province, required String? district}) async {
    setState(() {
      isLoading = true; // Bắt đầu quá trình tải, cập nhật UI
    });
    dbRef = FirebaseDatabase.instance
        .ref("Location")
        .child(province!)
        .child(district!);
    dataListLocal.clear();
    dbRef?.onValue.listen((event) {
      for (var snapshot in event.snapshot.children) {
        dataListLocal.add({"location": snapshot.value});
      }
      setState(() {
        isLoading = false; // tải hoàn tất
      });
    });
  }

  Future<void> getLoadLocationGps(
      {required String? province, required String? district}) async {
    setState(() {
      isLoadingGps = true; // Bắt đầu quá trình tải, cập nhật UI
    });
    dbRef = FirebaseDatabase.instance
        .ref("Location")
        .child(province!)
        .child(district!);
    dataListGps.clear();
    dbRef?.onValue.listen((event) {
      for (var snapshot in event.snapshot.children) {
        dataListGps.add({"location": snapshot.value});
      }
      setState(() {
        isLoadingGps = false; // Bắt đầu quá trình tải, cập nhật UI
      });
    });
  }

  Widget getLocationFromGPS() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "Vị trí hiện tại: $_currentAddress",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
          ),
          if (isLoadingGps)
            const CircularProgressIndicator() // Hiển thị loading spinner khi đang tải
          else
            Expanded(
              child: isLoadingGps
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Hiển thị spinner khi đang tải
                  : dataListGps.isEmpty
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
                                child: loadLocation(
                                    dataListGps[index]['location']));
                          }),
            )
        ],
      ),
    );
  }

  _checkPermissions() async {
    bool serviceEnabled;
    LocationPlugin.PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == LocationPlugin.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != LocationPlugin.PermissionStatus.granted) {
        return;
      }
    }
  }

  _getCurrentLocation() async {
    _checkPermissions();
    try {
      LocationPlugin.LocationData locationData = await location.getLocation();
      setState(() {
        _currentPosition = locationData;
      });

      _getAddressFromLatLng(locationData.latitude!, locationData.longitude!);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<GeocodingPlugin.Placemark> placeMarks =
          await GeocodingPlugin.placemarkFromCoordinates(latitude, longitude);
      GeocodingPlugin.Placemark place = placeMarks[0];
      //subAdministrativeArea: tên quận
      //administrativeArea: tên tp
      String t = "Thành phố " "${place.administrativeArea}";
      setState(() {
        _currentAddress = "$t, ${place.subAdministrativeArea},";
      });

      getLoadLocationGps(province: t, district: place.subAdministrativeArea);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
}

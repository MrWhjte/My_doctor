import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../Auth/Login.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late List<Map<String, dynamic>> dataList = [];
  late var idUser = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final Map<dynamic, dynamic> invoiceData;
  DatabaseReference? dbRef;
  bool isLoadIdUser = true;
  late List<DateTime> highlightedDays = [];
  final DateTime today = DateTime.now();
  int t = 0;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    // if (highlightedDays.isEmpty) {
    //   // Hiển thị loader hoặc thông báo trong khi dữ liệu đang được tải
    //   return const Center(child: CircularProgressIndicator());
    // }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Lịch dùng thuốc",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        monthCellBuilder: (BuildContext context, MonthCellDetails details) {
          final bool isHighlighted = highlightedDays.any((day) =>
              day.year == details.date.year &&
              day.month == details.date.month &&
              day.day == details.date.day);
          final bool isToday = details.date.year == today.year &&
              details.date.month == today.month &&
              details.date.day == today.day;
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isHighlighted
                  ? Colors.blue.withOpacity(0.5)
                  : Colors.transparent,
              border:
                  Border.all(color: Colors.green.withOpacity(0.9), width: 0.2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (isToday)
                  CircleAvatar(
                    backgroundColor: Colors.red.withOpacity(0.6),
                    // Màu viền của ngày hôm nay
                    radius: 15,
                    // Đặt kích thước của CircleAvatar
                    child: Text(
                      details.date.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                else
                  Text(
                    details.date.day.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                if (isHighlighted)
                  const Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        'Dùng thuốc',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  List<DateTime> getHighlightedDays(List<String> days) {
    DateTime x = DateTime.now();
    DateTime today = DateTime(x.year, x.month, x.day);
    List<DateTime> highlightedDays = [];

    for (String day in days) {
      int numDay = int.parse(day);
      DateTime date = DateTime(today.year, today.month, numDay);
      highlightedDays.add(date);
    }
    return highlightedDays;
  }

  void filterOutPastDays() {
    DateTime today = DateTime.now();
    today = DateTime(
        today.year, today.month, today.day); // Chỉ xét đến năm, tháng, ngày
    if (mounted) {
      setState(() {
        highlightedDays = highlightedDays
            .where((day) => day.isAtSameMomentAs(today) || day.isAfter(today))
            .toList();
      });
    }
  }

  Future<void> loadData() async {
    String id = await getUserID();
    dbRef = FirebaseDatabase.instance.ref(id);
    dbRef?.onValue.listen((event) {
      dataList.clear();
      for (var snapshot in event.snapshot.children) {
        var dayValue = snapshot.child('Day').value;
        if (dayValue == null) {
          continue;
        }
        String dayStr = snapshot.child('Day').value.toString();
        dayStr = dayStr.replaceAll('[', '').replaceAll(']', '');
        List<String> dayList = dayStr.split(', ');
        if (mounted) {
          setState(() {
            highlightedDays = getHighlightedDays(dayList);
            filterOutPastDays();
          });
        }
      }
    });

    if (id.isNotEmpty) {
      if (mounted) {
        setState(() {
          idUser = id;
          isLoadIdUser = false;
        });
      }
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
}

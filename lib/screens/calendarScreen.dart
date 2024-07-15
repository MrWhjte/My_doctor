import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_doctor/Main_Function/linhtinh2.dart';
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
  late List<Appointment> appointments = [];
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
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                showAgenda: true,
              ),
              dataSource: MeetingDataSource(appointments),
              monthCellBuilder: (BuildContext context, MonthCellDetails details) {
                final bool isHighlighted = highlightedDays.any((day) =>
                day.year == details.date.year &&
                    day.year == details.date.year &&
                    day.month == details.date.month &&
                    day.day == details.date.day);
                final bool isToday = details.date.year == today.year &&
                    details.date.month == today.month &&
                    details.date.day == today.day;
                return
                   Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? Colors.greenAccent
                          : Colors.transparent,
                      border:
                      Border.all(color: Colors.black, width: 0.2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (isToday)
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 15,
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
                      ],
                    ),
                  );
              },
            ),
          );
  }

  void filterOutPastDays() {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day); // Chỉ xét đến năm, tháng, ngày
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
          var dayValue = snapshot
              .child('DayMonth')
              .value;
          if (dayValue == null) {
            continue; // Bỏ qua nếu giá trị là null
          }

          String dayStr = dayValue.toString();
          dayStr = dayStr.replaceAll('[', '').replaceAll(']', '');
          List<String> dayList = dayStr.split(', ');

          setState(() {
            highlightedDays = getHighlightedDays(dayList);
            appointments=getAppointments(dayList);
          });
          if (highlightedDays.isNotEmpty) {
            filterOutPastDays(); // Lọc các ngày đã qua
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

  List<DateTime> getHighlightedDays(List<String> dayMonthList) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    List<DateTime> highlightedDays = [];

    for (String dayMonth in dayMonthList) {
      try {
        List<String> parts = dayMonth.split('/');
        if (parts.length != 2) {
          continue;
        }
        int numDay = int.parse(parts[0]);
        int numMonth = int.parse(parts[1]);
        int numYear = currentYear;

        // Điều chỉnh năm nếu cần thiết
        //6/5
        if (numMonth < now.month || (numMonth == now.month && numDay < now.day)) {
          numYear++;
        }
        DateTime date = DateTime(numYear, numMonth, numDay);

        // Chỉ thêm ngày thuộc tháng hiện tại hoặc tháng kế tiếp
        if ((date.month == now.month || date.month == (now.month + 1)) ||
            (now.month == 12 && date.month == 1)) {
          highlightedDays.add(date);
        }
      } catch (e) {
        debugPrint('Lỗi khi chuyển đổi day/month: "$dayMonth". Exception: $e');
      }
    }
    return highlightedDays;
  }

  List<Appointment> getAppointments(List<String> dayMonthList) {
    List<Appointment> appointments = [];
    DateTime now = DateTime.now();
    int currentYear = now.year;

    for (String dayMonth in dayMonthList) {
      try {
        List<String> parts = dayMonth.split('/');
        if (parts.length != 2) {
          continue;
        }
        int numDay = int.parse(parts[0]);
        int numMonth = int.parse(parts[1]);
        int numYear = currentYear;

        if (numMonth < now.month || (numMonth == now.month && numDay < now.day)) {
          numYear++;
        }
        DateTime date = DateTime(numYear, numMonth, numDay);
        if ((date.month == now.month || date.month == (now.month + 1)) ||
            (now.month == 12 && date.month == 1)) {
          appointments.add(Appointment(
            startTime: DateTime(numYear, numMonth, numDay,7),
            endTime: DateTime(numYear, numMonth, numDay,22),
            subject: 'Dùng thuốc',
            color: Colors.deepPurpleAccent,
          ));
        }
      } catch (e) {
        debugPrint('Lỗi khi chuyển đổi day/month: "$dayMonth". Exception: $e');
      }
    }
    return appointments;
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

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<String> tagSession = [];
  final List<String> optionSession = [
    'Sáng',
    'Trưa',
    'Tối',
  ];
  List<String> tagTime = [];
  final List<String> optionTime = [
    '7:00',
    '8:00',
    '12:00',
    '13:00',
    '16:00',
    '17:00',
    '19:00',
    '22:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        // Đảm bảo background container khớp với bottom sheet
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(30)), // Bo góc cho container nếu cần
      ),
      child: Column(
        children: [
          const SizedBox(
              width: 100,
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 5,
                  indent: 1,
                ),
              )),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Center(
              child: Text(
                "Đặt lịch nhắc nhở",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Chọn buổi dùng thuốc",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
           Wrap(
              spacing: 20, // Khoảng cách ngang giữa các chips
              runSpacing: 8.0, // Khoảng cách dọc giữa các hàng chips
              children: List<Widget>.generate(
                optionSession.length,
                (int index) {
                  return ChoiceChip(
                    label: Text(optionSession[index]),
                    selected: tagSession.contains(optionSession[index]),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          tagSession.add(optionSession[index]);
                        } else {
                          tagSession.removeWhere((String name) {
                            return name == optionSession[index];
                          });
                        }
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.greenAccent,
                    // Màu khi được chọn
                    labelStyle: TextStyle(
                      color: tagSession.contains(optionSession[index])
                          ? Colors.black
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side:  BorderSide(
                            color: Colors.black.withOpacity(0.1)) // Viền màu khi chưa được chọn
                        ),
                  );
                },
              ),
            ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Đặt giờ nhận thông báo",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 20, // Khoảng cách ngang giữa các chips
              runSpacing: 8.0, // Khoảng cách dọc giữa các hàng chips
              children: List<Widget>.generate(
                optionTime.length,
                    (int index) {
                  return ChoiceChip(
                    label: Text(optionTime[index]),
                    selected: tagTime.contains(optionTime[index]),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          tagTime.add(optionTime[index]);
                        } else {
                          tagTime.removeWhere((String name) {
                            return name == optionTime[index];
                          });
                        }
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.greenAccent,
                    // Màu khi được chọn
                    labelStyle: TextStyle(
                      color: tagTime.contains(optionTime[index])
                          ? Colors.black
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side:  BorderSide(
                            color: Colors.black.withOpacity(0.1)) // Viền màu khi chưa được chọn
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
             Expanded(
               child: ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.of(context).pop({'tagSession':tagSession,'tagTime':tagTime});
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      shadowColor: Colors.black.withOpacity(0.5),
                      elevation: 20),
                  child: const Text('đồng ý',
                      style: TextStyle(color: Colors.white, fontSize: 20))),
             ),
              const SizedBox(width: 5),
            Expanded(
              child: ElevatedButton(
                  onPressed: ()
                  {
                    setState(()
                    {
                      Navigator.of(context).pop();
                    });
              
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      shadowColor: Colors.black.withOpacity(0.5),
                      elevation: 20),
                  child: const Text('Thoát',
                      style: TextStyle(color: Colors.white, fontSize: 20))),
            ),
          ],)
        ],
      ),
    );
  }

}

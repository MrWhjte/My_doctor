import 'package:flutter/material.dart';

class GetInformationOnEachName extends StatefulWidget {
  const GetInformationOnEachName({super.key});

  @override
  _GetInformationOnEachNameState createState() =>
      _GetInformationOnEachNameState();
}

class _GetInformationOnEachNameState extends State<GetInformationOnEachName> {
  final _otherUse = TextEditingController();
  List<String> tagSession = [];
  final List<String> optionSession = [
    'Sáng',
    'Trưa',
    'Chiều',
    'Tối',
  ];
  List<String> tagNumAndHowToUse = [];
  final List<String> soLuong = [
    '1 viên',
    '2 viên',
    '3 viên',
    '4 viên',
    '1 muỗng',
    '2 muỗng',
    '3 muỗng'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Text(
                    "Cách dùng thuốc",
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
                        if (mounted) {
                          setState(() {
                            if (selected) {
                              tagSession.add(optionSession[index]);
                            } else {
                              tagSession.removeWhere((String name) {
                                return name == optionSession[index];
                              });
                            }
                          });
                        }
                      },
                      backgroundColor: Colors.white,
                      selectedColor: Colors.greenAccent,
                      labelStyle: TextStyle(
                        color: tagSession.contains(optionSession[index])
                            ? Colors.black
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side:
                              BorderSide(color: Colors.black.withOpacity(0.1))),
                      showCheckmark: false,
                    );
                  },
                ),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Số lượng uống ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 2, left: 2),
                child: Wrap(
                  spacing: 20, // Khoảng cách ngang giữa các chips
                  runSpacing: 8.0, // Khoảng cách dọc giữa các hàng chips
                  children: List<Widget>.generate(
                    soLuong.length,
                    (int index) {
                      return ChoiceChip(
                        label: Text(soLuong[index]),
                        selected: tagNumAndHowToUse.contains(soLuong[index]),
                        onSelected: (bool selected) {
                          if (mounted) {
                            setState(() {
                              if (selected) {
                                tagNumAndHowToUse.add(soLuong[index]);
                              } else {
                                tagNumAndHowToUse.removeWhere((String name) {
                                  return name == soLuong[index];
                                });
                              }
                            });
                          }
                        },
                        backgroundColor: Colors.white,
                        selectedColor: Colors.greenAccent,
                        labelStyle: TextStyle(
                          color: tagNumAndHowToUse.contains(soLuong[index])
                              ? Colors.black
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: Colors.black.withOpacity(0.1))),
                        showCheckmark: false,
                      );
                    },
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Hoặc cách sử dụng thuốc ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, bottom: 20),
                child: TextFormField(
                  controller: _otherUse,
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Nhập Cách dùng ',
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          if(_otherUse.text.isNotEmpty){
                            tagNumAndHowToUse.add(_otherUse.text);
                          }
                          Navigator.of(context).pop({
                            'tagSessionOnName': tagSession,
                            'tagUse': tagNumAndHowToUse
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            shadowColor: Colors.black.withOpacity(0.5),
                            elevation: 20),
                        child: const Text('Đồng ý',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20))),
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
                                borderRadius: BorderRadius.circular(50)),
                            shadowColor: Colors.black.withOpacity(0.5),
                            elevation: 20),
                        child: const Text('Thoát',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otherUse.dispose();
    super.dispose();
  }
}

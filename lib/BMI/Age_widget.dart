import 'package:flutter/material.dart';

class AgeWidget extends StatefulWidget {
  final Function(int) onChange;

  const AgeWidget({Key? key, required this.onChange}) : super(key: key);

  @override
  _AgeWidgetState createState() => _AgeWidgetState();
}

class _AgeWidgetState extends State<AgeWidget> {
  int _age = 25;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
          elevation: 12,
          shape: const RoundedRectangleBorder(),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              const Text(
                "Tuổi",
                style: TextStyle(fontSize: 25, color: Colors.black45,fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _age.toString(),
                    style: const TextStyle(color: Colors.green,fontSize: 40,fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Slider(
                activeColor: Colors.green,
                inactiveColor: Colors.grey,
                min: 0,
                max: 100,
                value: _age.toDouble(),
                thumbColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    _age = value.toInt();
                  });
                  widget.onChange(_age);
                },
              )
            ],
          )),
    );
  }
}

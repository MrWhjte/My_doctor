import 'package:flutter/material.dart';

class HeightWidget extends StatefulWidget {
  final Function(int) onChange;

  const HeightWidget({Key? key, required this.onChange}) : super(key: key);

  @override
  _HeightWidgetState createState() => _HeightWidgetState();
}

class _HeightWidgetState extends State<HeightWidget> {
  int _height = 150;

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
                "Chiều cao",
                style: TextStyle(fontSize: 25, color: Colors.black45,fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _height.toString(),
                    style: const TextStyle(color: Colors.blue,fontSize: 40,fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "cm",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )
                ],
              ),
              Slider(
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                min: 0,
                max: 300,
                value: _height.toDouble(),
                thumbColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    _height = value.toInt();
                  });
                  widget.onChange(_height);
                },
              )
            ],
          )),
    );
  }
}

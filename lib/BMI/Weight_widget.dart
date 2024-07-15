import 'package:flutter/material.dart';

class WeightWidget extends StatefulWidget {
  final Function(int) onChange;

  const WeightWidget({Key? key, required this.onChange}) : super(key: key);

  @override
  _WeightWidgetState createState() => _WeightWidgetState();
}

class _WeightWidgetState extends State<WeightWidget> {
  int _weight = 50;

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
                "Cân Nặng",
                style: TextStyle(fontSize: 25, color: Colors.black45,fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weight.toString(),
                    style: const TextStyle(color: Colors.green,fontSize: 40,fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Kg",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )
                ],
              ),
              Slider(
                activeColor: Colors.green,
                inactiveColor: Colors.grey,
                min: 0,
                max: 200,
                value: _weight.toDouble(),
                thumbColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    _weight = value.toInt();
                  });
                  widget.onChange(_weight);
                },
              )
            ],
          )),
    );
  }
}

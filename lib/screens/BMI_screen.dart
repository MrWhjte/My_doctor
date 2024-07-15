import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import '../BMI/Weight_widget.dart';
import '../BMI/gender_widget.dart';
import '../BMI/height_widget.dart';
import '../BMI/score_screen.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({Key? key}) : super(key: key);

  @override
  _BmiScreenState createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  int _gender = 0;
  int _height = 150;
  int _weight = 50;
  bool _isFinished = false;
  double _bmiScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Kiểm tra sức khoẻ",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body:  Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                //Lets create widget for gender selection
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Giới tính',
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        ),
                        GenderWidget(
                          onChange: (genderVal) {
                            _gender = genderVal;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                HeightWidget(
                  onChange: (heightVal) {
                    _height = heightVal;
                  },
                ),
                WeightWidget(
                  onChange: (weightVal) {
                    _weight = weightVal;
                  },
                ),
                // AgeWidget(
                //   onChange: (ageVal) {
                //     _age = ageVal;
                //   },
                // ),
                Expanded(child: Container()),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  child: SwipeableButtonView(
                      isFinished: _isFinished,
                      onFinish: () async {
                        await Navigator.push(
                            context,
                            PageTransition(
                                child: ScoreScreen(
                                  bmiScore: _bmiScore,
                                ),
                                type: PageTransitionType.fade));
                        setState(() {
                          _isFinished = false;
                        });
                      },
                      onWaitingProcess: () {
                        //Calculate BMI here
                        calculateBmi();
                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {
                            _isFinished = true;
                          });
                        });
                      },
                      activeColor: Colors.blue,
                      buttonWidget: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                      buttontextstyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20),
                      buttonText: "Kiểm tra"),
                )
              ],
            ),
          ),
        );
  }

  void calculateBmi() {
    _bmiScore = _weight / pow(_height / 100, 2);
  }
}

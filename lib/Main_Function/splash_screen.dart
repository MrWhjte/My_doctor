import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_doctor/Auth/Login.dart';
import 'package:my_doctor/Main_Function/openFile.dart';

class Splash extends StatefulWidget
{
    const Splash({super.key});

    @override
    State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash>
{
    double _opacity = 0;
    bool _showBtn=false;
    @override
    void initState()
    {
        // TODO: implement initState
        super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_) => _startFadeIn());
    }

    void _startFadeIn()
    {
        setState(()
            {
                _opacity = 1;
            });
        Future.delayed(const Duration(seconds: 2),()
            {
                setState(()
                    {
                        _showBtn = true; //show button when splash show
                    });
            });
    }
    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            body: Stack(
                children: [
                    Container(
                        width: double.infinity,
                        color: const Color(0xFF53CCD1),
                        child: AnimatedOpacity(
                            opacity: _opacity,
                            duration: const Duration(seconds: 2),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Image.asset('assets/images/logo.png', width: 200, height: 200),
                                    const Text('My Doctor', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w700))
                                ]
                            )
                        )
                    ),
                    if(_showBtn)
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 20), // Kho?ng cách t? ?áy
                            child:
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                      () => const Login(), transition: Transition.zoom,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
                                decoration: BoxDecoration(
                                  color:  const Color(0xFF76EEA3),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                        )
                    )
                ]
            )
        );
    }
}

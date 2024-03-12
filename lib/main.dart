import 'package:flutter/material.dart';

void main()
{
  runApp(MaterialApp(
      home: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: const Text('Demo App',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700))),
              body: const DemoApp())),
      debugShowCheckedModeBanner: false));
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

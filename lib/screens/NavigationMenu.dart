
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_doctor/Auth/Login.dart';
import 'package:my_doctor/Main_Function/openFile.dart';
import 'package:my_doctor/screens/proFile.dart';
import 'package:my_doctor/screens/setting.dart';
import 'package:move_to_background/move_to_background.dart';

import 'home.dart';

class NavigationMenu extends StatefulWidget
{
    const NavigationMenu({super.key});

    @override
    State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu>
{
    int index=0;
    @override
    Widget build(BuildContext context)
    {
      List<Widget> screens=const [HomeScreen(), Login(),OpenGallery(),Profile(),Setting()];
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (didPop) {
              return;
            }
            final bool? shouldPop = await _showBackDialog(context);
            if (shouldPop ?? false) {
              MoveToBackground.moveTaskToBack();
            }
          },
          child: Scaffold(
              body: screens[index],
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.green,
                  currentIndex: index,
                  onTap: (value)=>
                  {
                      setState(()
                          {
                              index = value;
                          }),
                  },
                  items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home_filled),
                          label: "Home"
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.calendar_month_outlined),
                          label: "Schedule"
                      ), BottomNavigationBarItem(
                          icon: Icon(Icons.qr_code_scanner_sharp),
                          label: "Scans"
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.perm_identity),
                          label: "Profile"
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings),
                          label: "Setting"
                      )
                  ]
              )

          ),
        );
    }

    Future<bool?> _showBackDialog(BuildContext context) async {
      final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thoát ứng dụng?'),
            content: Text('Bạn có muốn thoát ứng dụng?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Thoát'),
              ),
            ],
          );
        },
      );
      return result;
    }



}




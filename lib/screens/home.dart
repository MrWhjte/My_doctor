import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:my_doctor/FuncHomeScreen/Map.dart';
import 'package:my_doctor/FuncHomeScreen/abc.dart';

class HomeScreen extends StatefulWidget
{
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
    List catNames = [
        'Categor',
        'Classes',
        'Free Course',
        'BookStore',
        'Live Course',
        'Tra cứu thông tin quầy bán',
    ];
    List<Color> catColor = const [
        Color(0xFFFFCF2F),
        Color(0xFF6FEe8D),
        Color(0xFF61BDFD),
        Color(0xFFFC7F7F),
        Color(0xFFCB84FB),
        Color(0xFF78E667)
    ];
    List<Icon> catIcon = const [
        Icon(Icons.category, color: Colors.white, size: 50),
        Icon(Icons.video_library, color: Colors.white, size: 50),
        Icon(Icons.assessment, color: Colors.white, size: 50),
        Icon(Icons.store, color: Colors.white, size: 50),
        Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
        Icon(Icons.location_on, color: Colors.white, size: 50)
    ];

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            body: ListView(
                children: [
                    Container(
                        padding:
                        const EdgeInsets.only(top: 15, bottom: 10, right: 15, left: 15),
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        child:
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Icon(Icons.dashboard, color: Colors.white, size: 30),
                                        Icon(color: Colors.white, Icons.notifications, size: 30)
                                    ]),
                                const SizedBox(height: 20),
                                const Padding(
                                    padding: EdgeInsets.only(left: 3, bottom: 15),
                                    child: Text('Hello ...',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1,
                                            wordSpacing: 2))),
                                Container(
                                    margin: const EdgeInsets.only(top: 5, bottom: 20),
                                    width: MediaQuery.of(context).size.width,
                                    height: 55,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Search here...",
                                            hintStyle: TextStyle(
                                                color: Colors.black.withOpacity(0.5),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                            prefixIcon: const Icon(Icons.search, size: 30)))
                                )
                            ])),
                    Padding(
                        padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
                        child: Column(children: [
                                GridView.builder(
                                    itemCount: catNames.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,crossAxisSpacing: 3,
                                        mainAxisSpacing: 10,),
                                    itemBuilder: (BuildContext context, int index)
                                    {
                                        return  Column(
                                              children: [
                                                  InkWell(
                                                      onTap: ()
                                                      {
                                                        forwardCat(index);
                                                      },
                                                      child: Container(
                                                          height: 70,
                                                          width: 70,
                                                          decoration: BoxDecoration(
                                                              color: catColor[index], shape: BoxShape.circle),
                                                          child: Center(child: catIcon[index]))
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Expanded(
                                                    child: Text(
                                                        catNames[index],
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 16),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  )
                                              ]
                                          );
                                        
                                    }
                                ),
                                const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Functions',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w600)),
                                        Text('Show all',style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.w500))
                                    ]
                                )
                            ]
                        )
                    )
                ]
            )
        )
        ;
    }

  void forwardCat(int key) {
    switch (key) {
      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const map()));
        break;
    }

  }
}

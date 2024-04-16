import 'package:flutter/material.dart';
import '../Main_Function/ScansScreen.dart';

class Medicine extends StatefulWidget
{
    const Medicine({super.key});

    @override
    State<Medicine> createState() => _MedicineState();
}

class _MedicineState extends State<Medicine>
{
    @override
    Widget build(BuildContext context)
    {
        return   Scaffold(
            body: SingleChildScrollView(
                child: Padding(
                    padding:  const EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    const Text(
                                        "Your Medicine",
                                        style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                    InkWell(onTap: () {
                                       Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => const ScansScreen()));
                                    },
                                        child: const Icon(Icons.qr_code_scanner_sharp,size: 40,color: Colors.blue,))
                                ]
                            ),
                            const SizedBox(height: 40),
                            const Center(
                              child: Text(
                                  "khong co du lieu",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                            ),
                            const SizedBox(height: 20),
                          card(),

                        ]
                    )
                )
            )
        );
    }
    Widget card(){
      return
        Card(
            color: Colors.white70,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: InkWell(
                    onTap: ()
                    {

                    },
                    child: const Text(
                      'abc'
                    ),
                ),
            )
        );
    }
}

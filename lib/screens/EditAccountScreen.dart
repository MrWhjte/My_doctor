import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../Main_Function/EditItem.dart';

class EditAccountScreen extends StatefulWidget
{
    const EditAccountScreen({super.key});

    @override
    State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen>
{
    String gender = "man";
    File? getImage;
    

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    onPressed: ()
                    {
                        Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_outlined)
                ),
                leadingWidth: 80,
                actions: [
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                            onPressed: ()
                            {
                              Fluttertoast.showToast(msg: 'success');
                            },
                            style: IconButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                fixedSize: const Size(60, 50),
                                elevation: 3
                            ),
                            icon: const Icon(Icons.check, color: Colors.white)
                        )
                    )
                ]
            ),
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const Text(
                                "Account",
                                style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            const SizedBox(height: 40),
                            EditItem(
                                title: "Photo",
                                widget: Column(
                                    children: [
                                        getImage != null
                                        ?SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: ClipOval(
                                              child: Image.file(
                                              getImage!,
                                                fit: BoxFit.cover, // Cover the entire area
                                              ),
                                          ),
                                        )
                                        // Image.file(getImage!)
                                        :Image.asset(
                                            "assets/images/avatar.png",
                                            height: 100,
                                            width: 100
                                        ),
                                        TextButton(
                                            onPressed: ()
                                            {
                                                _getImages();
                                            },
                                            style: TextButton.styleFrom(
                                                foregroundColor: Colors.lightBlueAccent
                                            ),
                                            child: const Text("Upload Image")
                                        )
                                    ]
                                )
                            ),
                            const EditItem(
                                title: "Name",
                                widget: TextField()
                            ),
                            const SizedBox(height: 40),
                            EditItem(
                                title: "Gender",
                                widget: Row(
                                    children: [
                                        IconButton(
                                            onPressed: ()
                                            {
                                                setState(()
                                                    {
                                                        gender = "man";
                                                    });
                                            },
                                            style: IconButton.styleFrom(
                                                backgroundColor: gender == "man"
                                                ? Colors.deepPurple
                                                : Colors.grey.shade200,
                                                fixedSize: const Size(50, 50)
                                            ),
                                            icon: Icon(
                                                Icons.male,
                                                color: gender == "man" ? Colors.white : Colors.black,
                                                size: 18
                                            )
                                        ),
                                        const SizedBox(width: 20),
                                        IconButton(
                                            onPressed: ()
                                            {
                                                setState(()
                                                    {
                                                        gender = "woman";
                                                    });
                                            },
                                            style: IconButton.styleFrom(
                                                backgroundColor: gender == "woman"
                                                ? Colors.deepPurple
                                                : Colors.grey.shade200,
                                                fixedSize: const Size(50, 50)
                                            ),
                                            icon: Icon(
                                                Icons.female,
                                                color: gender == "woman" ? Colors.white : Colors.black,
                                                size: 18
                                            )
                                        )
                                    ]
                                )
                            ),
                            const SizedBox(height: 40),
                            const EditItem(
                                widget: TextField(),
                                title: "Age"
                            ),
                            const SizedBox(height: 40),
                            const EditItem(
                                widget: TextField(),
                                title: "Email"
                            )
                        ]
                    )
                )
            )
        );
    }
    Future _getImages() async
    {
        var getimg = await ImagePicker().pickImage(source: ImageSource.gallery);
        setState(()
            {
              getImage = File(getimg!.path);
            });
    }
}

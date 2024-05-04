import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_doctor/screens/setting.dart';

import '../Main_Function/EditItem.dart';
import 'NavigationMenu.dart';

class EditAccountScreen extends StatefulWidget
{
    const EditAccountScreen({super.key});

    @override
    State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen>
{
  final FirebaseAuth auth = FirebaseAuth.instance;
    String  email ="";
    String gender = "man";
    File? imageAvatar;
    final _nameController = TextEditingController();
    final _ageController = TextEditingController();
    final _phoneController = TextEditingController();
    final _emailController = TextEditingController();
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadEmail();
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _ageController.dispose() ;
    _phoneController.dispose();
  }
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
                              uploadUserProfile();
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
                                "Edit Account",
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
                                        imageAvatar != null
                                        ?SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: ClipOval(
                                              child: Image.file(
                                              imageAvatar!,
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
                             EditItem(
                                title: "Name",
                                widget: TextFormField(controller: _nameController,)
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
                            const SizedBox(height: 20),
                             EditItem(
                                widget: TextFormField(controller: _ageController,),
                                title: "Age"
                            ),
                            const SizedBox(height: 20),
                             EditItem(
                                widget: TextFormField(controller: _emailController,enabled: false,),
                                title: "Email"
                            ),
                          const SizedBox(height: 20),
                             EditItem(
                                widget: TextFormField(controller: _phoneController,),
                                title: "Phone"
                            )
                        ]
                    )
                )
            )
        );
    }

    Future<void> uploadUserProfile() async
    {
      String idUser = await getUserID();
      if(idUser.isEmpty)
      {
        Fluttertoast.showToast(msg: 'Have error');
      }
      //
      // if( _nameController.text.isEmpty |gender.isEmpty|_ageController.text.isEmpty|_phoneController.text.isEmpty){
      //   Fluttertoast.showToast(msg: "vui lòng nhập đầy đủ thông tin");
      //   return;
      // }

      String imageUrl = "";
      if (imageAvatar != null) {
        imageUrl = await uploadImageToFirebaseStorage(imageAvatar!);
        if (imageUrl.isEmpty) {
          Fluttertoast.showToast(msg: 'Failed to upload image.');
          return;
        }
      }
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref(idUser);
      var invoiceRef = databaseReference.child("Profile");
      Map<String, dynamic> invoiceData = {
        'Name': _nameController.text,
        'Gender': gender,
        'Age': _ageController.text,
        'Phone': _phoneController.text,
        'Avatar':imageUrl,
      };
      await invoiceRef.set(invoiceData);
      _nameController.text="";
      _ageController.text="";
      _phoneController.text="";
      imageAvatar=null;
        goto();
      Fluttertoast.showToast(msg: 'Add success!');
    }

void goto(){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>  const NavigationMenu(index: 4,),
    ),
  );
}

    Future<String> getUserID() async
    {
      final User? user = auth.currentUser;
      if (user != null)
      {
        return user.uid;
      } else
      {
        Fluttertoast.showToast(msg: 'login to continue');
        return "";

      }
    }
    Future<String> getUserEmail() async
    {
      final User? user = auth.currentUser;
      if (user != null)
      {
        return user.email.toString();
      } else
      {
        Fluttertoast.showToast(msg: 'login to continue');
        return "";
      }
    }

    Future _getImages() async
    {
        var getimg = await ImagePicker().pickImage(source: ImageSource.gallery);
        setState(()
            {
              imageAvatar = File(getimg!.path);
            });
    }

  void loadEmail() async{
    String emailUser = await getUserEmail();
      setState(() {
        email = emailUser;
        _emailController.text = email;
      });
  }

  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    String idUser = await getUserID();
    if(idUser.isEmpty)
    {
      Fluttertoast.showToast(msg: 'Have error');
    }
    final userProfileImageRef = FirebaseStorage.instance.ref(idUser).child('Avatars').child('avatar.jpg');
      await userProfileImageRef.putFile(imageFile);
      final imageUrl = await userProfileImageRef.getDownloadURL();
      debugPrint(imageUrl.toString());
      return imageUrl;
  }
}

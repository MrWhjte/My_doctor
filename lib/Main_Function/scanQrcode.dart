import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class testGoogleKit extends StatefulWidget
{
    const testGoogleKit({super.key});

    @override
    State<testGoogleKit> createState() => _testGoogleKitState();
}

class _testGoogleKitState extends State<testGoogleKit>
{

    XFile? pickImage;
    String text="";
    bool scanning=false;

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            // appBar: AppBar(
            //     centerTitle: true,
            //     backgroundColor: Colors.blue,
            //     title: const Text('Demo App',
            //         style: TextStyle(
            //             color: Colors.white, fontWeight: FontWeight.w700))),
            floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    FloatingActionButton(
                        onPressed: ()
                        {
                            _getImages();
                        },
                        child: const Icon(Icons.add)),
                    FloatingActionButton(
                        onPressed: ()
                        {
                            _getImages();
                        },
                        child: const Icon(Icons.camera))
                ]),
            body: Column(
                children: [
                    Container(
                        margin: const EdgeInsets.all(20),
                        child: SizedBox(
                            width: 500,
                            height: 100,
                            child: pickImage != null
                            ? Center(child: Image.file(File(pickImage!.path)))
                            : Center(
                                child: setText("Images is empty",
                                    color: Colors.black, fontSize: 20)))
                    ),
                    Container(
                        width: 400,
                        height: 600,
                        margin: const EdgeInsets.all(10),
                        child: Column(
                            children: [
                                // TextField(
                                //     controller: _controller,
                                // )
                                Expanded(

                                    child: SingleChildScrollView(
                                        child: setText(text,
                                            color: Colors.black, fontSize: 15))
                                )
                            ]))
                ]));
    }

    Widget setText(String text, {Color? color, double? fontSize})
    {
        return Text(text,
            style: TextStyle(color: Colors.black, fontSize: fontSize));
    }

    _getImages()async
    {
        XFile? result=await ImagePicker().pickImage(source: ImageSource.gallery) ;
        if(result!=null)
        {
            setState(()
                {
                    pickImage=result;
                });
            extractTextView();
        }

    }
    extractTextView() async
    {
        setState(()
            {
                scanning=true;
            });
        try
        {
            final inputImage =InputImage.fromFilePath(pickImage!.path);
            final oCR= GoogleMlKit.vision.textRecognizer();
            final recognizedText= await oCR.processImage(inputImage);
            setState(()
                {
                    text=recognizedText.text;
                    scanning=false;
                });
            oCR.close();
        }catch(e)
        {
            debugPrint("Error: $e");
        }
    }

}

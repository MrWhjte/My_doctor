import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OpenGallery extends StatefulWidget
{
    const OpenGallery({super.key});

    @override
    State<OpenGallery> createState() => _OpenGalleryState();
}

class _OpenGalleryState extends State<OpenGallery>
{
    File? getImage;

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.blue,
                title: const Text('Demo App',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700))),
            floatingActionButton:FloatingActionButton(
                onPressed: ()
                {
                    _getImages();
                }, child: const Icon(Icons.add)
            ),
            body: Column(
                children: [

                    Center(
                      child: Container(
                          color: Colors.red,
                          width: 200,
                        height: 300,
                        child: getImage!= null ? Image.file(getImage!):
                        Center(child: setText("Images is empty",color: Colors.black,fontSize: 20)),
                      ),
                    ),
                    _extractTextView()
                ]
            )
        );
    }
    Widget setText(String text,{Color? color,double? fontSize})
    {
        return Text(text,style:  TextStyle(color: Colors.black,fontSize: fontSize));
    }

    Future _getImages() async
    {
        final getimg =  await  ImagePicker().pickImage(source: ImageSource.gallery);
        setState(()
            {
                getImage = File(getimg!.path);
            });
    }
    Widget _extractTextView()
    {
        if(getImage==null)
        {
            return  Center(
                child: setText('no result'));
        }
        return FutureBuilder(future: _extractText(getImage!), builder: (context,snapshot)
            {
                debugPrint(snapshot.data);
                return setText(snapshot.data??"",color: Colors.black,fontSize: 15);
            });
    }

    Future<String?> _extractText(File file) async
    {
        final textRecognized= TextRecognizer(script: TextRecognitionScript.latin);
        final  InputImage inputImage= InputImage.fromFile(file);
        final RecognizedText  recognizedText = await textRecognized.processImage(inputImage);
        String text=recognizedText.text;
        textRecognized.close();
        return text;

    }
}

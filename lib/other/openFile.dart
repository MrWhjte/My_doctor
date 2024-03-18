import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regexpattern/regexpattern.dart';
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
            // appBar: AppBar(
            //     centerTitle: true,
            //     backgroundColor: Colors.blue,
            //     title: const Text('Demo App',
            //         style: TextStyle(
            //             color: Colors.white, fontWeight: FontWeight.w700))),
            floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    FloatingActionButton(
                        onPressed: ()
                        {
                            _getImages();
                        }, child: const Icon(Icons.add)
                    ),
                    FloatingActionButton(
                        onPressed: ()
                        {
                            _getImagesFromCamera();
                        }, child: const Icon(Icons.camera)
                    )
                ]
            ),

            body: Column(
                children: [
                    Center(
                        child: SizedBox(
                            width: 500,
                            height: 200,
                            child: getImage!= null ? Image.file(getImage!):
                            Center(child: setText("Images is empty",color: Colors.black,fontSize: 20))
                        )
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
    Future _getImagesFromCamera() async
    {
        final getimg =  await  ImagePicker().pickImage(source: ImageSource.camera);
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
                child: setText('No result')
            );
        }
        return FutureBuilder(future: _extractText(getImage!), builder: (context,snapshot)
            {
                if (snapshot.connectionState == ConnectionState.waiting)
                {
                    return Container(
                        margin: const EdgeInsets.all(15),
                        child: const Center(
                            child: CircularProgressIndicator(color: Colors.blue))
                    );
                }else
                {
                    // final TextEditingController _controller = TextEditingController();
                    String result  = snapshot.data??"";
                    // _controller.text=result;
                    String name    = getDataFromImage("Họ và tên / Full name:", result);
                    String birthDay= getDataFromImage("Ngày sinh / Date of birth:", result);
                    String sex= getDataFromImage("Giói tính / Sex:", result,num: 3);
                    String placeOfOrigin= getDataFromImage("Quê quán / Place of origin:", result);
                    String place= getDataFromImage("Place of residençe:", result);

                    return Container(
                        margin: const EdgeInsets.all(15),
                        child: SizedBox(
                            //"??" check snapshot.data is null
                            child: Column(
                                children: [
                                    setText(name,color: Colors.black,fontSize: 15),
                                    setText(birthDay,color: Colors.black,fontSize: 15),
                                    setText(sex,color: Colors.black,fontSize: 15),
                                    setText(placeOfOrigin,color: Colors.black,fontSize: 15),
                                    setText(place,color: Colors.black,fontSize: 15),
                                ]
                            )
                        )
                    );
                }
            }
        );
    }
    String getDataFromImage(String dataFind,String dataRss,{int? num})
    {
        int startIndex= dataRss.indexOf(dataFind) + dataFind.length+1 ;
        int endIndex;
        if(num!=null){
             endIndex = startIndex+3;
        }else{
         endIndex= dataRss.indexOf("\n",startIndex);}
        String result= dataRss.substring(startIndex,endIndex);
        return result;
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

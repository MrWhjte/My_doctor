// import 'dart:io';
// import 'dart:math';
// import 'helper.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image_picker/image_picker.dart';
// import 'unWantedWords.dart';
//
//
// class ScansScreen extends StatefulWidget
// {
//     const ScansScreen({super.key});
//
//     @override
//     State<ScansScreen> createState() => _ScansScreenState();
// }
//
// class _ScansScreenState extends State<ScansScreen>
// {
//     File? getImage;
//
//     @override
//     Widget build(BuildContext context)
//     {
//         return Scaffold(
//             // appBar: AppBar(
//             //     centerTitle: true,
//             //     backgroundColor: Colors.blue,
//             //     title: const Text('Demo App',
//             //         style: TextStyle(
//             //             color: Colors.white, fontWeight: FontWeight.w700))),
//             floatingActionButton:
//             Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//                     FloatingActionButton(
//                         onPressed: ()
//                         {
//                             _getImages();
//                         },
//                         child: const Icon(Icons.add)),
//                     FloatingActionButton(
//                         onPressed: ()
//                         {
//                             _getImagesFromCamera();
//                         },
//                         child: const Icon(Icons.camera))
//                 ]),
//             body: Column(
//                 children: [
//                     Container(
//                         margin: const EdgeInsets.all(20),
//                         child: SizedBox(
//                             width: 500,
//                             height: 100,
//                             child: getImage != null
//                             ? Image.file(getImage!)
//                             : Center(
//                                 child: setText("Images is empty",
//                                     color: Colors.black, fontSize: 20)))),
//                     _extractTextView()
//                 ]));
//     }
//
//
//
//     Future _getImages() async
//     {
//         var getimg = await ImagePicker().pickImage(source: ImageSource.gallery);
//         setState(()
//             {
//                 getImage = File(getimg!.path);
//             });
//     }
//
//     Future _getImagesFromCamera() async
//     {
//         final getimg = await ImagePicker().pickImage(source: ImageSource.camera);
//         setState(()
//             {
//                 getImage = File(getimg!.path);
//             });
//     }
//
//     Widget _extractTextView()
//     {
//         if (getImage == null)
//         {
//             return Container(child: setText('No result'));
//         }
//
//         return FutureBuilder(
//             future: _extractText(getImage!),
//             builder: (context, snapshot)
//             {
//                 // final TextEditingController _controller = TextEditingController();
//                 if (snapshot.connectionState == ConnectionState.waiting)
//                 {
//                     return Container(
//                         margin: const EdgeInsets.all(15),
//                         child: const Center(
//                             child: CircularProgressIndicator(color: Colors.blue)));
//                 } else
//                 {
//                     // final TextEditingController _controller = TextEditingController();
//                     String result = snapshot.data ?? "";
//                     String nameUser = Helper().getNameUser(result);
//                     String nameProduct = Helper().getNameProduct(result);
//                     List<String> listNameProduct = Helper().getListNameProduct(result);
//                     // _controller.text=result;
//                     return SizedBox(
//                         width: 400,
//                         height: 600,
//                         child: Column(children: [
//                                 // TextField(
//                                 //     controller: _controller,
//                                 // )
//                                 Expanded(
//                                     flex: 2,
//                                     child: SingleChildScrollView(
//                                         child:
//                                         setText(result, color: Colors.black, fontSize: 15))
//                                 ),
//                                 Expanded(
//                                     child: Column(children: [
//                                             setText("Tên khách hàng: $nameUser",color: Colors.black, fontSize: 20),
//                                             setText(nameProduct,color: Colors.black, fontSize: 20),
//                                             const SizedBox(height: 10),
//                                             setText('List of medicine',color: Colors.blue,fontSize: 20),
//                                             Expanded(
//                                                 child: ListView.builder(
//                                                     itemCount: listNameProduct.length, // S? l??ng items trong danh sách
//                                                     itemBuilder: (context, index)
//                                                     {
//                                                         return Text(listNameProduct[index], style: const TextStyle(fontSize: 20));
//                                                     }
//                                                 )
//                                             )
//                                         ]))
//                             ]));
//                 }
//             });
//     }
//
//     Future<String?> _extractText(File file) async
//     {
//         final textRecognized = TextRecognizer(script: TextRecognitionScript.latin);
//         final InputImage inputImage = InputImage.fromFile(file);
//         final RecognizedText recognizedText =
//         await textRecognized.processImage(inputImage);
//         String text = recognizedText.text;
//         textRecognized.close();
//         return text;
//     }
//
//     List<Widget> buildDrugList(List<String> drugNames)
//     {
//         return drugNames.map((name) => Text(name)).toList();
//     }
//
//     String getDataFromImage(String dataFind, String dataRss, {int? num})
//     {
//         int startIndex = dataRss.indexOf(dataFind) + dataFind.length + 1;
//         int endIndex;
//         if (num != null)
//         {
//             endIndex = startIndex + 3;
//         } else
//         {
//             endIndex = dataRss.indexOf("\n", startIndex);
//         }
//         String result = dataRss.substring(startIndex, endIndex);
//         return result;
//     }
//     Widget setText(String text, {Color? color, double? fontSize})
//     {
//         return Text(text,
//             style: TextStyle(color: Colors.black, fontSize: fontSize));
//     }
// }

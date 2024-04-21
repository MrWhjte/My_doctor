// FirebaseAnimatedList(
// query: dbRef!,
// itemBuilder: (context, snapshot, animation, index) {
// debugPrint("${snapshot.child("id").value}");
// // debugPrint(snapshot.key);
// return const Padding(
// padding: const EdgeInsets.only(top: 5.0),
// child: Column(
// children: [
// // Text(snapshot.child("id").value.toString()),
// // // Text(snapshot.child("name").value.toString()),
// // Text(time),
// ],
// ),
// );
// }),


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      home: InvoiceScreen(),
    );
  }
}

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final dbRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice List"),
      ),
      body: FutureBuilder(
        future: dbRef.child('ZbpaXJI1r7NiZSCpKxElSsK1EQt1/Invoices').get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
            Map<dynamic, dynamic> values = snapshot.data.snapshot.value;
            List<dynamic> items = [];
            values.forEach((key, values) {
              items.add(values);
            });
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Invoice ID: ${items[index]['id']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Time: ${items[index]['time']}"),
                      Text("Products: ${items[index]['name']['name1'] ?? ''} ${items[index]['name']['name2'] ?? ''}"),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowDataScreen(invoiceId: items[index]['id']),
                    ),
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class ShowDataScreen extends StatelessWidget {
  final String invoiceId;

  ShowDataScreen({required this.invoiceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice Details"),
      ),
      body: Center(
        child: Text("Details for Invoice ID: $invoiceId"),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class DatabaseMethods {
//   Future<void> addMedicine(Map<String, dynamic> medicineInfo) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc('userID')
//           .collection('medicines')
//           .add(medicineInfo);
//       Fluttertoast.showToast(msg: 'Thuốc đã được thêm thành công!');
//     } catch (error) {
//       Fluttertoast.showToast(msg:'Lỗi khi thêm thuốc: $error');
//     }
//   }
//
//   Future<QuerySnapshot> getthisUserInfo(String name) async {
//     return await FirebaseFirestore.instance
//         .collection("users")
//         .where("First Name", isEqualTo: name)
//         .get();
//   }
//
//   Future UpdateUserData(String age, String id) async {
//     return await FirebaseFirestore.instance
//         .collection("users")
//         .doc(id)
//         .update({"Age": age});
//   }
//
//   Future DeleteUserData(String id)async{
//     return await FirebaseFirestore.instance.collection("users").doc(id).delete();
//   }
// }
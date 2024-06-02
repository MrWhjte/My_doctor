// import 'package:firebase_database/firebase_database.dart';
// import 'notifications.dart';
//
// void setupReminderListener() {
//   DatabaseReference reminderRef = FirebaseDatabase.instance.reference().child('reminders');
//
//   reminderRef.onChildAdded.listen((event) {
//     var data = event.snapshot.value as Map<dynamic, dynamic>;
//     var times = (data['times'] as List<dynamic>).map((time) => DateTime.parse(time)).toList();
//     scheduleReminders(times);
//   });
//
//   reminderRef.onChildChanged.listen((event) {
//     var data = event.snapshot.value as Map<dynamic, dynamic>;
//     var times = (data['times'] as List<dynamic>).map((time) => DateTime.parse(time)).toList();
//     scheduleReminders(times);
//   });
// }

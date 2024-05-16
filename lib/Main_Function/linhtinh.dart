Padding(
padding: const EdgeInsets.only(left: 20),
child: Row(
children: [
const Text('Cách dùng :',
style: TextStyle(
color: Colors.black,
fontSize: 16,
fontWeight: FontWeight.w400)),
Text(
medicines[index]['use'].isNotEmpty
?  medicines[index]['use']
    : ' Không có',
style:
const TextStyle(color: Colors.black),
),
],
),
),
Padding(
padding: const EdgeInsets.only(left: 20),
child: Row(
children: [
const Text('Giờ uống :',
style: TextStyle(
color: Colors.black,
fontSize: 16,
fontWeight: FontWeight.w400)),
Text(
medicines[index]['time'].isNotEmpty
?  medicines[index]['time']
    : ' Không có',
style:
const TextStyle(color: Colors.black),
),
],
),
),
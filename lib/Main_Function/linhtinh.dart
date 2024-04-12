// class MyWidget extends StatefulWidget {
//   @override
//   _MyWidgetState createState() => _MyWidgetState();
// }
//
// class _MyWidgetState extends State<MyWidget> {
//   bool _showPassword = true; // Initialize the variable
//
//   void _togglePasswordVisibility() {
//     setState(() {
//       _showPassword = !_showPassword; // Toggle the value
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ẩn hiện mật khẩu'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Mật khẩu',
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _showPassword ? Icons.visibility : Icons.visibility_off,
//                   ),
//                   onPressed: _togglePasswordVisibility, // Toggle when tapped
//                 ),
//               ),
//               obscureText: _showPassword, // Use the variable
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

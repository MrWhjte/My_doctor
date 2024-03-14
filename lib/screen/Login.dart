import 'package:flutter/material.dart';
import '../values/app_style.dart';

class Login extends StatefulWidget
{
    const Login({super.key});

    @override
    State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool rememberUser = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bac.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black,
                    BlendMode.dstATop
                )
            )
        ),
        child: Container(
            margin: const EdgeInsets.only(top: 100, bottom: 100),
            child: Card(
                color: Colors.white.withOpacity(0.2),
                margin: const EdgeInsets.all(10),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text('Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontFamily: FontFamily.openSans,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 20),
                          _inputAccount(),
                          const SizedBox(height: 10),
                          _inputPass(),
                          const SizedBox(height: 10),
                          _checkRemember(),
                          const SizedBox(height: 5),
                          _btnLogin(),
                          const SizedBox(height: 5),
                          const Text('Or Login with',style: TextStyle(color: Colors.white,fontSize: 15),),
                          const SizedBox(height: 10),
                          _anotherLogin(),

                        ]
                    )
                )
            )
        )
    );
  }

  Widget _checkRemember() {
    return
      Row(
        children: [
          Checkbox(
              value: rememberUser,
              onChanged: (value) {
                setState(() {
                  rememberUser = value!;
                });
              }),
          _setText("Remember me"),
          TextButton(onPressed: (){}, child: _setText("I forgot my password"))
        ],
      );
  }
  Widget _setText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400),
    );
  }
  Widget _inputPass() {
    return
      const TextField(
          style: TextStyle(color: Colors.white, fontSize: 15),
          obscureText: true,
          decoration: InputDecoration(
              labelText: 'Password', border: OutlineInputBorder()));
  }

  Widget _inputAccount() {
    return
      const TextField(
          style: TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
              labelText: 'Account', border: OutlineInputBorder()));
  }

  Widget _btnLogin() {
    return
      Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 10),
          child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.near_me_sharp,
                  color: Colors.white),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  shadowColor: Colors.black.withOpacity(0.5),
                  elevation: 20),
              label: const Text('Login',
                  style: TextStyle(
                      color: Colors.white, fontSize: 20)
              )
          )
      );
  }
}

Widget _anotherLogin(){
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(icon: Image.asset("assets/icon/fb.png")),
        const SizedBox(width: 10,),
        Tab(icon: Image.asset("assets/icon/gmail.png")),
      ],
    ),
  );
}

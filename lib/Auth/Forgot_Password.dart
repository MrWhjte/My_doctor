import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_doctor/Auth/signUp.dart';
import '../values/app_style.dart';
import 'Login.dart';

class ForgotPassword extends StatefulWidget
{
    const ForgotPassword({super.key});

    @override
    State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
{
    String email = "";
    final _email=TextEditingController();

    resetPassUser()
    async
    {
        if(email.isEmpty)
        {
            Fluttertoast.showToast(msg:'Please enter your account ');
        }else
        {
            try
            {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                Fluttertoast.showToast(msg: 'Password Reset Email has been sent !"');
                Get.to(const Login());
            } on FirebaseAuthException catch (e)
            {
                if (e.code == "user-not-found")
                {
                    Fluttertoast.showToast(msg: 'No user found for that email.');
                }
            }
        }
    }
    @override
    void dispose()
    {
        // TODO: implement dispose
        super.dispose();
        _email.dispose();
    }
    @override
    Widget build(BuildContext context)
    {
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
                margin: const EdgeInsets.only(top: 150 , bottom: 150),
                child:Card(
                    color: Colors.white.withOpacity(0.2),
                    margin: const EdgeInsets.all(15),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                const SizedBox(height: 40),
                                const Text('Reset PassWord',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontFamily: FontFamily.openSans,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 20),
                                _inputAccount(),
                                const SizedBox(height: 10),
                                _btnRsPass(),
                                const SizedBox(height: 10),
                                const Text('Or Login with',style: TextStyle(color: Colors.white,fontSize: 18)),
                                const SizedBox(height: 10),
                                _anotherLogin()
                            ]
                        )

                    )
                )

            )
        );
    }

    Widget _setText(String text)
    {
        return Text(
            text,
            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400)
        );
    }

    Widget _inputAccount()
    {
        return
        TextFormField(
            validator: (value)
            {
                if (value == null || value.isEmpty)
                {
                    Fluttertoast.showToast(msg: 'Please Enter E-mail',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.transparent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                }
                return null;
            },
            controller: _email,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: const InputDecoration(
                labelText: 'Account', border: OutlineInputBorder()));
    }

    Widget _btnRsPass()
    {
        return
        Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton.icon(
                onPressed: ()
                {
                    setState(()
                        {
                            email= _email.text;
                            _email.text='';
                        });
                    resetPassUser();
                },
                icon: const Icon(Icons.near_me_sharp,
                    color: Colors.white),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    shadowColor: Colors.black.withOpacity(0.5),
                    elevation: 20),
                label: const Text('Send email reset',
                    style: TextStyle(
                        color: Colors.white, fontSize: 20)
                )
            )
        );
    }
    _goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUp())
    );

    Widget _anotherLogin()
    {
        return Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Tab(icon: Image.asset("assets/icon/fb.png")),
                    const SizedBox(width: 10),
                    Tab(icon: Image.asset("assets/icon/gmail.png"))
                ]
            )
        );
    }
}

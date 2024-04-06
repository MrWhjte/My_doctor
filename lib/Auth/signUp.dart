import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../other/openFile.dart';
import '../values/app_style.dart';
import 'Login.dart';

class SignUp extends StatefulWidget
{
    const SignUp({super.key});

    @override
    State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>
{

    // final _auth = AuthService();
    String email = "", password = "",passwordAgain = "", name = "";
    final TextEditingController _nameUser = TextEditingController();
    final TextEditingController _email = TextEditingController();
    final TextEditingController _password = TextEditingController();
    final TextEditingController _passwordAgain = TextEditingController();

    final _formkey = GlobalKey<FormState>();
    registration() async
    {
        if (password.isNotEmpty && _nameUser.text!=""&& _email.text!="")
        {
            try
            {
                await FirebaseAuth.instance
                .createUserWithEmailAndPassword(email: email, password: password);
                Fluttertoast.showToast(msg: "Registered Successfully");
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const Login()));
            } on FirebaseAuthException catch (e)
            {
                if (e.code == 'weak-password')
                {
                    Fluttertoast.showToast(msg: "Password Provided is too Weak");
                } else if (e.code == "email-already-in-use")
                {
                    Fluttertoast.showToast(msg: "Account Already exists");
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
        _password.dispose();
        _passwordAgain.dispose();
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
                                const Text('SignUp',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50,
                                        fontFamily: FontFamily.openSans,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 20),
                                _inputNameUser(),
                                const SizedBox(height: 20),
                                _inputAccount(),
                                const SizedBox(height: 10),
                                _inputPass(),
                                const SizedBox(height: 10),
                                _inputPassAgain(),
                                const SizedBox(height: 10),
                                _btnSignUp(),
                                const SizedBox(height: 10),
                                _signUpText()
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
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400)
        );
    }

    Widget _inputPass()
    {
        return
        TextFormField(
            validator: (value)
            {
                if (value == null || value.isEmpty)
                {
                    return 'Please Enter Password';
                }
                return null;
            },
            controller:_password,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            obscureText: true,
            decoration: const InputDecoration(
                suffixIcon: Icon(Icons.remove_red_eye),
                labelText: 'Password', border: OutlineInputBorder()));
    }

    Widget _inputPassAgain()
    {
        return
        TextFormField(
            validator: (value)
            {
                if (value == null || value.isEmpty)
                {
                    return 'Please Enter Password Again';
                }
                return null;
            },
            controller: _passwordAgain,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            obscureText: true,
            decoration: const InputDecoration(
                suffixIcon: Icon(Icons.remove_red_eye),
                labelText: 'input password again', border: OutlineInputBorder()));
    }

    Widget _inputAccount()
    {
        return
        TextFormField(
            validator: (value)
            {
                if (value == null || value.isEmpty)
                {
                    return 'Please Enter Email';
                }
                return null;
            },
            controller: _email,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: const InputDecoration(
                labelText: 'Account', border: OutlineInputBorder()));
    }
    Widget _inputNameUser()
    {
        return
        TextFormField(
            validator: (value)
            {
                if (value == null || value.isEmpty)
                {
                    return 'Please Enter Name';
                }
                return null;
            },
            controller: _nameUser,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: const InputDecoration(
                labelText: 'Name', border: OutlineInputBorder()));
    }

    Widget _signUpText()
    {
        return
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                const Text("I have an account? ",
                    style: TextStyle(fontSize: 15, color: Colors.white)),
                InkWell(
                    onTap: () => _goToLogIn(context),
                    child: const Text(
                        "Login", style: TextStyle(color: Colors.red, fontSize: 15))
                )
            ]
        );
    }

    Widget _btnSignUp()
    {
        return
        Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton.icon(
                onPressed: ()
                {
                    _signUp;
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
                label: const Text('SignUp',
                    style: TextStyle(
                        color: Colors.white, fontSize: 20)
                )
            )
        );
    }

    _goToLogIn(BuildContext context) =>
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login())
    );

    _signUp()
    {
      Fluttertoast.showToast(msg: 'check');
            setState(()
                {
                    email=_email.text;
                    name= _nameUser.text;
                    password=_password.text;
                    passwordAgain=_passwordAgain.text;
                });
            registration();
    }
    _goToHome(BuildContext context) =>
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OpenGallery())
    );
}


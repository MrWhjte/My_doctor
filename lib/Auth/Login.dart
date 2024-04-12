import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_doctor/Auth/signUp.dart';
import '../screens/NavigationMenu.dart';
import '../values/app_style.dart';
import 'package:my_doctor/Main_Function/openFile.dart';
import 'Forgot_Password.dart';

class Login extends StatefulWidget
{
    const Login({super.key});

    @override
    State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>
{
    String email = "", password = "";
    bool rememberUser = false;
    final _email = TextEditingController();
    final _password = TextEditingController();
    bool _showPassword = true;

    void _togglePasswordVisibility()
    {
        setState(()
            {
                _showPassword = !_showPassword; // Toggle the value
            });
    }

    final _formkey = GlobalKey<FormState>();

    userLogin() async
    {
        if (email.isEmpty || password.isEmpty)
        {
            Fluttertoast.showToast(msg: 'Please enter your account and password');
        } else
        {
            try
            {
                await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password);
                Fluttertoast.showToast(
                    msg: "Login Successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.transparent,
                    textColor: Colors.white,
                    fontSize: 16.0);
                // ignore: use_build_context_synchronously
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const NavigationMenu()));
            } catch (e)
            {
                Fluttertoast.showToast(msg: 'Account or password is not correct');
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
    }

    @override
    Widget build(BuildContext context)
    {
        return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bac.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                    ColorFilter.mode(Colors.black, BlendMode.dstATop))),
            child: Container(
                margin: const EdgeInsets.only(top: 100, bottom: 100),
                child: Card(
                    color: Colors.white.withOpacity(0.2),
                    margin: const EdgeInsets.all(10),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(children: [
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
                                const SizedBox(height: 10),
                                _btnLogin(),
                                const SizedBox(height: 10),
                                _signUp(),
                                const SizedBox(height: 10),
                                const Text('Or Login with',
                                    style: TextStyle(color: Colors.white, fontSize: 15)),
                                const SizedBox(height: 10),
                                _anotherLogin()
                            ])))));
    }

    Widget _checkRemember()
    {
        return Row(children: [
                Checkbox(
                    value: rememberUser,
                    onChanged: (value)
                    {
                        setState(()
                            {
                                rememberUser = value!;
                            });
                    }),
                _setText("Remember me"),
                const SizedBox(width: 5),
                InkWell(
                    onTap: () => _goToForgotPass(context),
                    child: _setText("I forgot my password"))
            ]);
    }

    Widget _setText(String text)
    {
        return Text(text,
            style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w400));
    }

    Widget _inputPass()
    {
        return TextFormField(
            validator: (value)
            {
                if (value == null || value.isEmpty)
                {
                    Fluttertoast.showToast(
                        msg: 'Please Enter E-mail',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.transparent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                }
                return null;
            },
            controller: _password,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            obscureText: _showPassword,
            decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: InkWell(
                    onTap: _togglePasswordVisibility,
                    child:
                    Icon(_showPassword ? Icons.visibility : Icons.visibility_off)
                )
            )
        );
    }

    Widget _inputAccount()
    {
        return TextFormField(
            validator: (value)
            {
                if (value == null || value.isEmpty)
                {
                    Fluttertoast.showToast(
                        msg: 'Please Enter Email',
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
                labelText: 'Account',
                border: OutlineInputBorder()
            )
        );
    }

    Widget _signUp()
    {
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Already have an account? ",
                    style: TextStyle(fontSize: 15, color: Colors.white)),
                InkWell(
                    onTap: () => _goToSignup(context),
                    child: const Text("Signup",
                        style: TextStyle(color: Colors.red, fontSize: 15)))
            ]);
    }

    Widget _btnLogin()
    {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton.icon(
                onPressed: ()
                {
                    setState(()
                        {
                            email = _email.text;
                            password = _password.text;
                        });
                    userLogin();
                },
                icon: const Icon(Icons.near_me_sharp, color: Colors.white),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    shadowColor: Colors.black.withOpacity(0.5),
                    elevation: 20),
                label: const Text('Login',
                    style: TextStyle(color: Colors.white, fontSize: 20))));
    }

    _goToSignup(BuildContext context) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignUp()));

    _goToForgotPass(BuildContext context) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ForgotPassword()));

    Widget _anotherLogin()
    {
        return Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Tab(icon: Image.asset("assets/icon/fb.png")),
                    const SizedBox(width: 10),
                    Tab(icon: Image.asset("assets/icon/gmail.png"))
                ]));
    }
}

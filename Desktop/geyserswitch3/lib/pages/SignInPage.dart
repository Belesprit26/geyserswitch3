import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geyserswitch3/Service/Auth_Service.dart';
import 'package:geyserswitch3/pages/SignUpPage.dart';
import 'HomePage.dart';
import 'forgot.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();
  bool _isObscure2 = true;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "v7",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 90,
                ),
                textItem("Email", _emailController, false),
                SizedBox(
                  height: 12,
                ),
                textItem2("Password", _pwController, true),
                SizedBox(
                  height: 30,
                ),
                colorButton(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account yet?  ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => SignUpPage()),
                            (route) => false);
                      },
                      child: circular
                          ? CircularProgressIndicator()
                          : Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      // side: BorderSide(color: Colors.black, width: 1),
                      ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Forgotpass()));
                  },
                  child: Text(
                    "Forgot Password ....",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        if (_formkey.currentState!.validate())
          try {
            firebase_auth.UserCredential userCredential =
                await firebaseAuth.signInWithEmailAndPassword(
                    email: _emailController.text, password: _pwController.text);
            print(userCredential.user!.email);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => HomePage()),
                (route) => false);
          } on firebase_auth.FirebaseAuthException catch (e) {
            var message = '';

            switch (e.code) {
              case 'invalid-email':
                message = 'The email you entered is invalid';
                break;
              case 'user-disabled':
                message = "This User's account has been disabled temporarily";
                break;
              case 'user-not-found':
                message =
                    "There is no user registered with this email and password";
                break;
              case "operation-not-allowed":
                message = "Too many requests to log into this account.";
                break;
              case "operation-not-allowed":
                message = "Server error, please try again later.";
                break;
              case 'wrong-password':
                message =
                    "The password entered does not match the email address/incorrect password";
                break;
              default:
                message =
                    "Login failed. Please re-enter your details and try again or check your internet connection.";
                break;
            }
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Failed to Log in'),
                    content: Text(message),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Ok')),
                    ],
                  );
                });
          }
        setState(() {
          circular = false;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 90,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [
            Color(0xfffd746c),
            Color(0xffff9068),
            Color(0xfffd746c),
          ]),
        ),
        child: Center(
          child: circular
              ? CircularProgressIndicator()
              : Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
        ),
      ),
    );
  }

  Widget buttonItem(
      String imagepath, String buttonName, double size, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                buttonName,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(
      String labelText, TextEditingController controller, bool obscureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 80,
      child: TextFormField(
        textAlign: TextAlign.center,
        validator: validateEmail,
        key: ValueKey('email'),
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: 'Enter email address',
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1.5,
              color: Colors.lightGreen,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget textItem2(
      String labelText, TextEditingController controller, bool obscureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 85,
      child: TextFormField(
        textAlign: TextAlign.center,
        validator: validatePassword,
        key: ValueKey('password'),
        controller: controller,
        obscureText: _isObscure2,
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: Icon(_isObscure2 ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _isObscure2 = !_isObscure2;
                });
              }),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1.5,
              color: Colors.lightGreen,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty)
    return 'An Email address is required';

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid Email Address format';

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty)
    return 'A Password is required';

  String pattern = r'^(?=.*?[0-9]).{6,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword))
    return '''
    Your Password would be at least 6 characters long,
    include an uppercase letter and a number 
    ''';

  return null;
}

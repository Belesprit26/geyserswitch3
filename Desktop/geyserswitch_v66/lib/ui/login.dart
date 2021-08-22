import 'package:geyserswitch_v66/utils/auth_helper.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget> [
              const SizedBox(height: 100.0,),
              Text(
                "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await AuthHelper.signInWithGoogle();
                    } catch (e) {
                      print(e);
                      }
                    },
                  child: Text("Login with Google"),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: "Enter email"),
              ),
              const SizedBox(height: 10.0,),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: "Enter Password"),
              ),
              const SizedBox(height: 10.0,),
              ElevatedButton(
                child: Text("Login"),
                onPressed: () async {
                  if (_emailController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                    print(" You need to provide a Email and Password");
                    return;
                  }
                  try {
                    final user = await AuthHelper.signInWithEmail(
                      email: _emailController.text,
                      password: _passwordController.text);
                    if (user != null) {
                      print("login successful");
                    }
                    } catch (e) {
                      print (e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

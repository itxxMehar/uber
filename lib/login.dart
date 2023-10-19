import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxiuber/passenger.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                      hintText: 'Enter valid mail id as abc@gmail.com'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter your secure password'
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  signInWithEmailAndPassword(email.text,password.text);
                },

                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      var a=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print(a.user?.uid);
      a.user?.uid=="yYahCWUfGkTJ5QI1gF5ixUSaIL93"?
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  passenger(ide: "driver",)),
      ):Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  passenger(ide: "passe",)),
      );
    } catch (e) {
      print('Error during login: $e');
    }
  }
}

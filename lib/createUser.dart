import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oil_mobile/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';




class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  final String title = 'Sign Up';


  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '',
      _password = '';


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,

                    child: Image.asset('images/oildrop.png')),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(

              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
                onChanged: (input) => _email = input,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(

                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                onChanged: (input) => _password = input,
              ),
            ),
            SizedBox(
              height: 50,
            ),

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.deepOrange, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _email, password: _password).then((value){
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (Route<dynamic> route) => false);
                        print('Signup success');

                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Welcome!'),
                          content:  Text('You have successfully created your account.'),
                          actions: <Widget>[
                            TextButton(onPressed: () => Navigator.pop(context, 'Dismiss'), child: const Text('Dismiss')),

                          ],
                        ));
                    child:const Text('Show Dialog');
                  }).catchError((error){
                    print('Signup failed');
                    print(error.toString());

                     showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Oops! Something went wrong..'),
                          content:  Text(error.toString()),
                          actions: <Widget>[
                            TextButton(onPressed: () => Navigator.pop(context, 'Cancel'), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(context, 'OK'), child: const Text('OK')),
                          ],
                        ));
                    child:const Text('Show Dialog');
                  });

                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
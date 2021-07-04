import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oil_mobile/createUser.dart';
import 'package:oil_mobile/main.dart';
import 'package:firebase_auth/firebase_auth.dart';




class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  final String title = 'Sign In & Sign Out';


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '',
      _password = '';

  //Check if user is logged in or not






  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top: 50.0),),
            RichText(

              text: TextSpan(
                  text:'My',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 38),
                  children: const<TextSpan>[
                    TextSpan(text: 'Oil', style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold, fontSize: 38) ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,

                    child: Image.asset('images/oildrop.png')),
              ),
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
              height: 30,
            ),

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.deepOrange, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _email, password: _password).then((value){
                        print('Login success');
                        Navigator.pushReplacementNamed(
                            context, '/Home');;
                  }).catchError((error){
                    print('Login failed');
                    print(error.toString());

                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Invalid email/password.'),
                          content:  Text(error.toString()),
                          actions: <Widget>[
                            TextButton(onPressed: () => Navigator.pop(context, 'Dismiss'), child: const Text('Dismiss')),

                          ],
                        ));
                    child:const Text('Show Dialog');
                  });

                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignUpPage()));
              },
              child: Text(
                'New user? Sign up here',
                style: TextStyle(color: Colors.deepOrange, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

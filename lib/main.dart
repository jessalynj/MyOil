// @dart=2.9


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:oil_mobile/login.dart';

import 'addCar.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  runApp(MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    User firebaseUser = FirebaseAuth.instance.currentUser;
// Define a widget
    Widget firstWidget;

// Assign widget based on availability of currentUser
    if (firebaseUser != null) {
      firstWidget = MyHomePage();
    } else {
      firstWidget = LoginPage();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ) ,
      home: firstWidget,
      routes:{
        '/Home': (_) => new MyHomePage(),
      }
    );
  }
}

class MyHomePage extends StatelessWidget {

  final ref = FirebaseFirestore.instance.collection('cars');

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getID(){
    final User user = _auth.currentUser;
    return user.uid;
  }

  //int welcomed = 0;


  Future <void >logout() async {
    await _auth.signOut();
    print('logout successful');

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        leading: new Container(),

        actions: <Widget>[
          FlatButton(onPressed:(){
            logout();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);


            }, //logout(),
              child: Text('Logout', style: TextStyle(fontSize: 18)), textColor: Colors.white)
        ],
        ),

        floatingActionButton: Container(
          height: 70,
          width: 70,
          child: FloatingActionButton(child: Icon(Icons.add),
            onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> AddCar()));
          },),
        ),
        body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            /*if(!snapshot.hasData && welcomed == 0){
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Getting Started'),
                    content: const Text('Welcome to MyOil! Click the + button to add your first car.'),
                    actions: <Widget>[
                      TextButton(
                          onPressed: (){welcomed = 1; Navigator.pop(context);},
                          child: const Text('Dismiss')),
                    ],
                  ));
              //child:const Text('Show Dialog');
            }*/
            return ListView.builder(
                itemCount: snapshot.hasData?snapshot.data.docs.length:0,
                itemBuilder: (_, index){
                  if(snapshot.data.docs[index].data()['uid'] == getID()){
                  return Card(
                    child: ListTile(
                      onLongPress:(){
                        //add option to delete this car
                      },
                      title: Container(
                        height: 100,
                        margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              /*1*/
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*2*/
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child:
                                    Text(
                                      (snapshot.data.docs[index].data()['name']),
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\n\nLast oil change: ' + getDateAsString(index, (snapshot.data.docs[index].data()['dateLastChanged']))  ,

                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            /*3*/
                            Icon(
                              Icons.access_time_outlined,
                              color: Colors.red[500],
                            ),
                            Text(timeToOilChange(index, snapshot.data.docs[index].data()['dateLastChanged'], snapshot.data.docs[index].data()['miles']),
                            style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),

                    ),
                  );
                }else {return Container(height:0);}});
          }
        )

      );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

String getDateAsString(index, Timestamp stamp){
  var date = new DateTime.fromMicrosecondsSinceEpoch(stamp.microsecondsSinceEpoch);
  String yearAsString = (formatDate(date, [yyyy]));
  String monthAsString = date.month.toString();

  return monthAsString + '/' + yearAsString;
}

String timeToOilChange(index, Timestamp stamp, String miles){
  var date = new DateTime.fromMicrosecondsSinceEpoch(stamp.microsecondsSinceEpoch);
  int res = DateTime.now().difference(date).inDays.round();
  int remainingTime;

  //If miles is average, change every 5 months
  if(miles == 'avg'){
    remainingTime = (5*30) - res;
    if(remainingTime <= 0){
      return '     ! ';
    }
  }

  //If miles is below average, change every 6 months
  if(miles == 'below'){
    remainingTime = (6*30) - res;
    if(remainingTime <= 0){
      return '     ! ';
    }
  }

  //If miles is above average, change every 4 months
  if(miles == 'above'){
    remainingTime = (4*30) - res;
    if(remainingTime <= 0){
      return '     ! ';
    }
  }

  return (' ' + (remainingTime/30).round().toString() + ' mo.');
}





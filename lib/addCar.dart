import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'login.dart';

class AddCar extends StatefulWidget {
  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCar>{

  //Used for checkboxes
  bool belowAvgValue = false;
  bool avgValue = false;
  bool aboveAvgValue = false;
  var miles;


  DateTime value = DateTime.now();

  TextEditingController name = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('cars');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getID(){
    final User user = _auth.currentUser;
    return user.uid;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add a car'),
        ),
        body: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB( 10, 20, 10, 5),
                child: Text('Car name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, )),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB( 10, 0, 10, 5),
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'What should we call this car?'),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text('Miles per year',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 3, 10, 10),
                child: Text('About how many miles does this car travel yearly?',
                    style: TextStyle(fontSize: 14)),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: CheckboxListTile(

                    title: Text('Less than average              <12,000 miles'),
                    value: belowAvgValue,
                    onChanged: (newValue) {
                      setState(() {
                        belowAvgValue = newValue!;
                        avgValue = aboveAvgValue = false;

                        miles = 'below';
                      });

                    }),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: CheckboxListTile(
                    title: Text(
                        'Average                   12,000 - 14,000 miles'),
                    value: avgValue,
                    onChanged: (newValue) {
                      setState(() {
                        avgValue = newValue!;
                        belowAvgValue = aboveAvgValue = false;

                        miles = 'avg';
                      });
                    }),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: CheckboxListTile(
                    title: Text('More than average             >14,000 miles'),
                    value: aboveAvgValue,
                    onChanged: (newValue) {
                      setState(() {
                        aboveAvgValue = newValue!;
                        belowAvgValue = avgValue = false;

                        miles = 'above';
                      });
                    }),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB( 10, 10, 10, 15),
                child: Text('Most recent oil change',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
              ),

              SizedBox(
                width: 250,
                height: 150,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: value,
                    onDateTimeChanged: (value) => setState(() => this.value = value),
                  )
              ),

              Container(
                padding: const EdgeInsets.fromLTRB( 10, 10, 10, 0),

                child: FlatButton(
                  color: Colors.deepOrange,
                    onPressed: () {
                  ref.add({
                    'uid': getID(),
                    'name': name.text,
                    'miles': miles,
                    'dateLastChanged': value
                  }).whenComplete(() => Navigator.pop(context));
                }, child: Text('Submit', style: TextStyle(fontSize: 18) ), textColor: Colors.white),
              )
            ]
        )
    );
  }
}




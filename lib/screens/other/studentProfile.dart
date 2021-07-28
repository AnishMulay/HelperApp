import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/screens/authScreens/login.dart';
import 'package:helper/screens/other/editStudentProfile.dart';
import 'package:helper/screens/other/splash.dart';
import 'package:helper/screens/other/studentCompleted.dart';
import 'package:helper/screens/other/studentHome.dart';
import 'package:helper/screens/other/studentSettings.dart';
import 'package:helper/screens/taskScreens/subscribed.dart';

String userId = '';
String displayName = '';
String email = '';
String phoneNumber = '';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({Key? key}) : super(key: key);

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Profile'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StudentSettingsPage()));
              },
              icon: Icon(Icons.settings)),
          IconButton(onPressed: () {
            AuthClass().signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentHomePage()));
                },
                icon: Icon(Icons.home)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Subscribed()));
                },
                icon: Icon(Icons.beenhere_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentProfilePage()));
                },
                icon: Icon(Icons.person)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentCompletedPage()));
                },
                icon: Icon(Icons.beenhere, color: Colors.green,)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(65.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
                heroTag: 'editProfileButton',
                child: Icon(Icons.edit),
                backgroundColor: Colors.blue,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditStudentProfile()));
                }),
            SizedBox(width: 10,),
            FloatingActionButton(
                heroTag: 'deleteProfileButton',
                child: Icon(Icons.delete),
                backgroundColor: Colors.red,
                onPressed: () {
                  FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.uid).delete().then(
                          (value) => {
                            FirebaseAuth.instance.currentUser.delete().then(
                                    (value) {
                                      deleteAccountDialogue(context);
                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.of(context).pop(true);
                                      }).then((value) {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Splash()));
                                      });
                                    })
                          });
                })
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              if(snapshot.connectionState != ConnectionState.done){
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Icon(
                      Icons.person,
                      size: 150,
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30,),
                          Row(
                            children: [
                              Text('User ID: '),
                              Text(userId),
                            ],
                          ),
                          SizedBox(height: 30,),
                          Row(
                            children: [
                              Text('Display Name: '),
                              Text(displayName),
                            ],
                          ),
                          SizedBox(height: 30,),
                          Row(
                            children: [
                              Text('Email: '),
                              Text(email),
                            ],
                          ),
                          SizedBox(height: 30,),
                          Row(
                            children: [
                              Text('Phone Number: '),
                              Text(phoneNumber),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  getUserData() async {
    userId = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('Users')
    .doc(userId)
    .get()
    .then((ds) {
      displayName = ds.data()['displayName'];
      email = ds.data()['email'];
      phoneNumber = ds.data()['phoneNumber'];
    });
  }

  void deleteAccountDialogue(BuildContext context) {
    var alertDialogue = AlertDialog(
      title: Text('Success'),
      content: Text('Account deleted'),
    );

    showDialog(
        context: context,
        builder: (BuildContext context){
          return alertDialogue;
        });
  }

}

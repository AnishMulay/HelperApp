import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
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
        title: Text('Student Profile', style: normal),
        actions: [
          MaterialButton(
              child: Text('Settings', style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StudentSettingsPage()));
              }),
          MaterialButton(
              child: Text('Logout', style: TextStyle(color: Colors.white),),
              onPressed: () {
                AuthClass().signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
              })
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
                child: Text('Home'),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentHomePage()));
                }),
            MaterialButton(
                child: Text('Subscribed'),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Subscribed()));
                }),
            MaterialButton(
                child: Text('Profile'),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentProfilePage()));
                }),
            MaterialButton(
                child: Text('Completed'),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentCompletedPage()));
                }),
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
                child: Text('Edit'),
                backgroundColor: Colors.blueAccent,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditStudentProfile()));
                }),
            SizedBox(width: 10,),
            FloatingActionButton(
                heroTag: 'deleteProfileButton',
                child: Text('Delete'),
                backgroundColor: Colors.redAccent,
                onPressed: () {
                  FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).delete().then(
                          (value) => {
                            FirebaseAuth.instance.currentUser!.delete().then(
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
                              Expanded(child: Text('Name: '+displayName, style: normal)),
                            ],
                          ),
                          SizedBox(height: 30,),
                          Row(
                            children: [
                              Text('Email: '+email, style: normal),
                            ],
                          ),
                          SizedBox(height: 30,),
                          Row(
                            children: [
                              Text('Phone Number: '+phoneNumber, style: normal),
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
    userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('Users')
    .doc(userId)
    .get()
    .then((ds) {
      displayName = ds.data()!['displayName'];
      email = ds.data()!['email'];
      phoneNumber = ds.data()!['phoneNumber'];
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

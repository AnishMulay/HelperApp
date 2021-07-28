import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/screens/authScreens/login.dart';
import 'package:helper/screens/other/editVolunteerProfile.dart';
import 'package:helper/screens/other/splash.dart';
import 'package:helper/screens/other/volunteerCompleted.dart';
import 'package:helper/screens/other/volunteerHome.dart';
import 'package:helper/screens/other/volunteerSettings.dart';
import 'package:helper/screens/taskScreens/volunteered.dart';

import 'editStudentProfile.dart';

String userId = '';
String displayName = '';
String email = '';
String phoneNumber = '';

class VolunteerProfilePage extends StatefulWidget {
  const VolunteerProfilePage({Key? key}) : super(key: key);

  @override
  _VolunteerProfilePageState createState() => _VolunteerProfilePageState();
}

class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Profile Page'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerSettingsPage()));
              },
              icon: Icon(Icons.settings)),
          IconButton(onPressed: () {
            //signout
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerHomePage()));
                },
                icon: Icon(Icons.home)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Volunteered()));
                },
                icon: Icon(Icons.beenhere_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerProfilePage()));
                },
                icon: Icon(Icons.person)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerCompletedPage()));
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditVolunteerProfile()));
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
                    )
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/screens/authScreens/login.dart';
import 'package:helper/screens/other/splash.dart';
import 'package:helper/screens/other/studentHome.dart';
import 'package:helper/screens/other/studentProfile.dart';
import 'package:helper/screens/other/studentSettings.dart';
import 'package:helper/screens/taskScreens/completedDetails.dart';
import 'package:helper/screens/taskScreens/subscribed.dart';
import 'package:helper/screens/taskScreens/taskNotify.dart';

class StudentCompletedPage extends StatefulWidget {
  const StudentCompletedPage({Key? key}) : super(key: key);

  @override
  _StudentCompletedPageState createState() => _StudentCompletedPageState();
}

class _StudentCompletedPageState extends State<StudentCompletedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks', style: normal),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tasks')
            .where('studentUserId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('isCompleted', isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData ?
          ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompletedTaskDetails(userId: auth.currentUser!.uid, taskId: ds.id,))
                    );
                  },
                  child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Text(ds['examTitle'], style: normal),
                            SizedBox(height: 20,),
                            Text(ds['address'], style: normal),
                            SizedBox(height: 20,),
                          ],
                        ),
                      )
                  ),
                );
              }) :
          Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

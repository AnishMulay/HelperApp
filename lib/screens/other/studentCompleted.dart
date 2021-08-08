import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper/providers/auth_provider.dart';
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
        title: Text('Completed Tasks', style: GoogleFonts.montserrat(fontSize: 18)),
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
                icon: Icon(Icons.beenhere, color: Colors.greenAccent,)),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tasks')
            .where('studentUserId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
                            builder: (context) => CompletedTaskDetails(userId: auth.currentUser.uid, taskId: ds.id,))
                    );
                  },
                  child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Text(ds['examTitle'], style: GoogleFonts.montserrat(fontSize: 18)),
                            SizedBox(height: 20,),
                            Text(ds['address'], style: GoogleFonts.montserrat(fontSize: 18)),
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

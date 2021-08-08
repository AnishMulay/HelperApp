import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/screens/authScreens/login.dart';
import 'package:helper/screens/other/studentCompleted.dart';
import 'package:helper/screens/other/studentHome.dart';
import 'package:helper/screens/other/studentProfile.dart';
import 'package:helper/screens/other/studentSettings.dart';
import 'package:helper/screens/taskScreens/subscribeTask.dart';
import 'package:helper/screens/taskScreens/taskDetails.dart';
import 'package:helper/screens/taskScreens/volunteered.dart';

class Subscribed extends StatefulWidget {
  const Subscribed({Key? key}) : super(key: key);

  @override
  _SubscribedState createState() => _SubscribedState();
}

class _SubscribedState extends State<Subscribed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribed Tasks', style: GoogleFonts.montserrat(fontSize: 18)),
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
            .where('isSubscribed', isEqualTo: true)
            .where('studentUserId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .where('isCompleted', isEqualTo: false).snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData ?
              ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetails(
                            userId: FirebaseAuth.instance.currentUser.uid,
                            taskId: ds.id)));
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
                        ),
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

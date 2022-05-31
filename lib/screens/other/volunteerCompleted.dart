import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/screens/authScreens/login.dart';
import 'package:helper/screens/other/volunteerHome.dart';
import 'package:helper/screens/other/volunteerProfile.dart';
import 'package:helper/screens/other/volunteerSettings.dart';
import 'package:helper/screens/taskScreens/completedDetails.dart';
import 'package:helper/screens/taskScreens/volunteered.dart';

class VolunteerCompletedPage extends StatefulWidget {
  const VolunteerCompletedPage({Key? key}) : super(key: key);

  @override
  _VolunteerCompletedPageState createState() => _VolunteerCompletedPageState();
}

class _VolunteerCompletedPageState extends State<VolunteerCompletedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks', style: normal),
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
                icon: Icon(Icons.beenhere, color: Colors.greenAccent,)),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tasks')
            .where('volunteer', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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

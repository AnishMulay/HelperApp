import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helper/screens/other/volunteerProfile.dart';
import 'package:helper/screens/other/volunteerSettings.dart';
import 'package:helper/screens/taskScreens/subscribeTask.dart';
import 'package:helper/screens/taskScreens/subscribed.dart';
import 'package:helper/screens/other/volunteerHome.dart';

class Volunteered extends StatefulWidget {
  const Volunteered({Key? key}) : super(key: key);

  @override
  _VolunteeredState createState() => _VolunteeredState();
}

class _VolunteeredState extends State<Volunteered> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteered tasks'),
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerSettingsPage()));
                },
                icon: Icon(Icons.settings)),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tasks')
            .where('isSubscribed', isEqualTo: true)
            .where('volunteer', isEqualTo: FirebaseAuth.instance.currentUser.uid).snapshots(),
        builder: (context, AsyncSnapshot snapshot){
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
                                builder: (context) => SubscribeTaskScreen(userId: FirebaseAuth.instance.currentUser.uid, taskId: ds.id,))
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              Text(ds['examTitle']),
                              SizedBox(height: 20,),
                              Text(ds['address']),
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

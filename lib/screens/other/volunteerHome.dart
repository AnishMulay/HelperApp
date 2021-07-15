import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helper/main.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/screens/other/studentHome.dart';
import 'package:helper/screens/taskScreens/subscribeTask.dart';
import 'package:helper/screens/taskScreens/subscribed.dart';
import 'package:helper/screens/taskScreens/volunteered.dart';
import '../authScreens/login.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String email = '';
String phoneNumber = '';
bool isStudent = false;

class VolunteerHomePage extends StatefulWidget {
  const VolunteerHomePage({Key? key}) : super(key: key);

  @override
  _VolunteerHomePageState createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends State<VolunteerHomePage> {

  @override
  void initState() {
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
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
                icon: Icon(Icons.beenhere_outlined))
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tasks').where('isSubscribed', isEqualTo: false).snapshots(),
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
                                builder: (context) => SubscribeTaskScreen(userId: auth.currentUser.uid, taskId: ds.id,))
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

getUserData() async {
  final firebaseUser = auth.currentUser;
  if(firebaseUser != null){
    await FirebaseFirestore.instance.collection('Users')
        .doc(firebaseUser.uid)
        .get()
        .then((ds) {
      email = ds.data()['displayName'];
      phoneNumber = ds.data()['phoneNumber'];
      isStudent = ds.data()['isStudent'];
    });
  }
}


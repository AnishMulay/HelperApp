import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/screens/other/splash.dart';
import 'package:helper/screens/other/studentProfile.dart';
import 'package:helper/screens/taskScreens/addTask.dart';
import 'package:helper/screens/taskScreens/subscribed.dart';
import 'package:helper/screens/taskScreens/taskNotify.dart';
import '../authScreens/login.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
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
                  print('settings');
                },
                icon: Icon(Icons.settings)),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 35,
        width: 35,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage()));
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Tasks')
                .where('isSubscribed', isEqualTo: false)
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
                                    builder: (context) => TaskNotify(userId: auth.currentUser.uid, taskId: ds.id,))
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

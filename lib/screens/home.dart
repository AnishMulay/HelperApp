import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/screens/taskScreens/addTask.dart';
import 'package:helper/screens/taskScreens/subscribeTask.dart';
import 'authScreens/login.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String email = '';
String phoneNumber = '';
bool isStudent = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
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
      body: Center(
        child: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot){
            if(snapshot.connectionState != ConnectionState.done){
              return Text('Loading data, please wait');
            }else{
              return isStudent == true ?
                    studentHomeScreen()
                  : volunteerHomeScreen();
            }
          },
        )
      ),
    );
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

  Widget studentHomeScreen(){
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(email.toString()),
            SizedBox(height: 15,),
            Text(phoneNumber.toString()),
            SizedBox(height: 250,),
            Align(
              alignment: Alignment.bottomCenter,
              child: RawMaterialButton(
                elevation: 2.0,
                fillColor: Colors.blue,
                shape: CircleBorder(),
                child: Icon(Icons.add, size: 30,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget volunteerHomeScreen(){
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tasks').where('isSubscribed', isEqualTo: false).snapshots(),
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
        });
  }
}

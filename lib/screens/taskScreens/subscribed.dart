import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helper/screens/taskScreens/subscribeTask.dart';
import 'package:helper/screens/taskScreens/volunteered.dart';

import '../home.dart';

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
        title: Text('Subscribed Tasks'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Icon(Icons.home)),
            IconButton(
                onPressed: () {
                  if(isStudent == true){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Subscribed()));
                  }
                  else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Volunteered()));
                  }
                },
                icon: Icon(Icons.beenhere_outlined))
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tasks')
            .where('isSubscribed', isEqualTo: true)
            .where('studentUserId', isEqualTo: FirebaseAuth.instance.currentUser.uid).snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData ?
              ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        print('Card tapped');
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helper/screens/taskScreens/editTask.dart';

import '../other/studentHome.dart';

String examTitle = '';
String address = '';
String volunteerId = '';
bool isSubscribed = false;

class TaskDetails extends StatefulWidget {
  final String userId, taskId;
  const TaskDetails({Key? key, required this.userId, required this.taskId}) : super(key: key);

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
                heroTag: 'editButton',
                child: Icon(Icons.edit),
                backgroundColor: Colors.blue,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditTaskPage(userId: FirebaseAuth.instance.currentUser.uid, taskId: widget.taskId,))
                  );
                }),
            SizedBox(width: 10,),
            FloatingActionButton(
                heroTag: 'deleteButton',
                child: Icon(Icons.delete),
                backgroundColor: Colors.red,
                onPressed: () {
                  FirebaseFirestore.instance.collection('Tasks').doc(widget.taskId).delete().then(
                          (value) {
                            deleteAccountDialogue(context);
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.of(context).pop(true);
                            }).then((value) => {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => StudentHomePage()))
                            });
                          }).catchError((error) => {
                            print(error.toString())
                  });
                }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: FutureBuilder(
            future: getTaskData(),
            builder: (context, snapshot) {
              if(snapshot.connectionState != ConnectionState.done){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }else{
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Text('Task ID: '),
                          Text(widget.taskId),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Text('Exam Title: '),
                          Text(examTitle),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Text('Exam Address: '),
                          Text(address),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Text('Who has volunteered'),
                      SizedBox(height: 10,),
                      Text(volunteerId)
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  getTaskData() async {
    await FirebaseFirestore.instance.collection('Tasks')
        .doc(widget.taskId)
        .get()
        .then((ds) {
      examTitle = ds.data()['examTitle'];
      address = ds.data()['address'];
      isSubscribed = ds.data()['isSubscribed'];
      volunteerId = ds.data()['volunteer'];
    });
  }

  void deleteAccountDialogue(BuildContext context) {
    var alertDialogue = AlertDialog(
      title: Text('Success'),
      content: Text('Task deleted'),
    );

    showDialog(
        context: context,
        builder: (BuildContext context){
          return alertDialogue;
        });
  }

}



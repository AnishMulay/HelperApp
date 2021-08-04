import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/screens/other/editStudentProfile.dart';

String examTitle = '';
String address = '';
String examDateTime = '';
String studentId = '';
bool isSubscribed = false;
bool isLiked = false;

class SubscribeTaskScreen extends StatefulWidget {
  final String userId, taskId;
  const SubscribeTaskScreen({Key? key, required this.userId, required this.taskId}) : super(key: key);

  @override
  _SubscribeTaskScreenState createState() => _SubscribeTaskScreenState();
}

class _SubscribeTaskScreenState extends State<SubscribeTaskScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe to task'),
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
              }
              else{
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Text('Task ID:  '),
                          Text(widget.taskId),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Text('Exam Title:  '),
                          Text(examTitle),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Text('Exam Address:  '),
                          Text(address),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Text('Exam Date and Time:  '),
                          Text(examDateTime),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Subscribe to this task ?'),
                          SizedBox(width: 10,),
                          Switch(
                              value: isSubscribed,
                              onChanged: (value) {
                                setState(() {
                                  isSubscribed = value;
                                  FirebaseFirestore.instance.collection('Tasks').doc(widget.taskId).update(
                                      {'isSubscribed': isSubscribed});
                                  if(value == true){
                                    FirebaseFirestore.instance.collection('Tasks').doc(widget.taskId).update(
                                        {'volunteer': FirebaseAuth.instance.currentUser.uid});
                                  }
                                  else{
                                    FirebaseFirestore.instance.collection('Tasks').doc(widget.taskId).update(
                                        {'volunteer': 'None'});
                                  }
                                });
                              }),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Center(
                        child: MaterialButton(
                          color: Colors.blue,
                            child: Text('Add to favorites'),
                            onPressed: () async {
                              QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Likes')
                                  .where('volunteerId', isEqualTo: widget.userId)
                                  .where('studentId', isEqualTo: studentId)
                                  .where('taskId', isEqualTo: widget.taskId)
                                  .get();

                              if(snapshot.docs.isNotEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Already added'),
                                ));
                              } else {
                                AuthClass().addLike(
                                  volunteerId: widget.userId,
                                  studentId: studentId,
                                  taskId: widget.taskId
                                );
                              }
                            }),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
      )
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
          examDateTime = ds.data()['examDateTime'];
          studentId = ds.data()['studentUserId'];
    });

  }

}


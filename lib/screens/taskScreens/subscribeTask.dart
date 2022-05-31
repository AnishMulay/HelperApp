import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/screens/other/editStudentProfile.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

String examTitle = '';
String address = '';
String examDateTime = '';
String studentId = '';
bool isSubscribed = false;
bool isLiked = false;
String displayName = '';
String email = '';
String phoneNumber = '';

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
        title: Text('Subscribe to task', style: normal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: FutureBuilder(
            future: getTaskAndUserData(),
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
                          Text('Exam Title: '+examTitle, style: normal),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Text('Exam Address: '+address, style: normal),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Text('Exam Date and Time: '+examDateTime, style: normal),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Subscribe to this task ?', style: normal),
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
                                        {'volunteer': FirebaseAuth.instance.currentUser!.uid});
                                    sendSubscribeEmail(email, examTitle, displayName, phoneNumber);
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
                          color: Colors.blueAccent,
                            child: Text('Add to favorites', style: normal),
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

  getTaskAndUserData() async {
    await FirebaseFirestore.instance.collection('Tasks')
        .doc(widget.taskId)
        .get()
        .then((ds) {
          examTitle = ds.data()!['examTitle'];
          address = ds.data()!['address'];
          isSubscribed = ds.data()!['isSubscribed'];
          examDateTime = ds.data()!['examDateTime'];
          studentId = ds.data()!['studentUserId'];
    });

    await FirebaseFirestore.instance.collection('Users')
        .doc(widget.userId)
        .get()
        .then((ds) {
      displayName = ds.data()!['displayName'];
      email = ds.data()!['email'];
      phoneNumber = ds.data()!['phoneNumber'];
    });
  }

  sendSubscribeEmail(String rEmail, String title, String name, String phone) async {
    String senderEmail = 'Jagritischoolclass10@gmail.com';
    String senderPassword = 'Jagriti@123';

    final smtpServer = gmail(senderEmail, senderPassword);
    final message = Message()
      ..from = Address(senderEmail, 'Jagriti')
      ..recipients.add(Address(rEmail))
      ..subject = 'Task Notification Email'
      ..text = 'The task' +title+ ' has been subscribed to by the volunteer ' +name+ ' , their phone number is' + phone;

    await send(message, smtpServer);
  }
}


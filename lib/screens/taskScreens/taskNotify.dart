import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../other/studentHome.dart';
import 'editTask.dart';

String examTitle = '';
String address = '';
String volunteerId = '';
String examDateTime = '';
bool isSubscribed = false;

class TaskNotify extends StatefulWidget {
  final String userId, taskId;
  const TaskNotify({Key? key, required this.userId, required this.taskId}) : super(key: key);

  @override
  _TaskNotifyState createState() => _TaskNotifyState();
}

class _TaskNotifyState extends State<TaskNotify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify Volunteers', style: GoogleFonts.montserrat(fontSize: 18)),
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
                backgroundColor: Colors.blueAccent,
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
                backgroundColor: Colors.redAccent,
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
                })
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
                            Text('Task ID: ', style: GoogleFonts.montserrat(fontSize: 18)),
                            Text(widget.taskId),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          children: [
                            Text('Exam Title: ', style: GoogleFonts.montserrat(fontSize: 18)),
                            Text(examTitle),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          children: [
                            Text('Exam Address: ', style: GoogleFonts.montserrat(fontSize: 18)),
                            Text(address),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          children: [
                            Text('Exam Date and Time: ', style: GoogleFonts.montserrat(fontSize: 18)),
                            Text(examDateTime),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                                color: Colors.blueAccent,
                                child: Text('Send Email', style: GoogleFonts.montserrat(fontSize: 18)),
                                onPressed: () {
                                  sendAllEmails();
                                }),
                            SizedBox(width: 10,),
                          ],
                        )
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
      examDateTime = ds.data()['examDateTime'];
    });
  }

  sendEmail(String rEmail) async {
    String senderEmail = 'anishm7030@gmail.com';
    String senderPassword = 'Anish2000';

    final smtpServer = gmail(senderEmail, senderPassword);
    final message = Message()
      ..from = Address(senderEmail, 'Jagriti')
      ..recipients.add(Address(rEmail))
      ..subject = 'Task Notification Email'
      ..text = 'A new task has been created by a student, please open the app for more details';

    await send(message, smtpServer);
  }

  sendAllEmails() async {
    QuerySnapshot qs = await FirebaseFirestore.instance.collection('Users').where('isStudent', isEqualTo: false).get();
    var dataList = qs.docs.map((doc) => doc.data()['email']).toList();
    for(int i=0; i<dataList.length; i++){
      try{
        sendEmail(dataList[i]);
      }catch (e) {
        print(e.toString());
      }
    }
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

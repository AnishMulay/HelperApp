import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

String examTitle = '';
String address = '';
String volunteerId = '';
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
        title: Text('Notify Volunteers'),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                                color: Colors.blue,
                                child: Text('Send Notification Email'),
                                onPressed: () {
                                  sendAllEmails();
                                })
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
        print('email sent');
      }catch (e) {
        print(e.toString());
      }
    }
  }
}

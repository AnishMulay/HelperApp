import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String examTitle = '';
String address = '';
String volunteerId = '';
String examDateTime = '';

class CompletedTaskDetails extends StatefulWidget {
  final String userId, taskId;
  const CompletedTaskDetails({Key? key, required this.userId, required this.taskId}) : super(key: key);

  @override
  _CompletedTaskDetailsState createState() => _CompletedTaskDetailsState();
}

class _CompletedTaskDetailsState extends State<CompletedTaskDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Task Details'),
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
              } else {
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
                        children: [
                          Text('Exam Date and Time: '),
                          Text(examDateTime),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Text('Who has Completed'),
                      SizedBox(height: 10,),
                      Text(volunteerId),
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
      volunteerId = ds.data()['volunteer'];
      examDateTime = ds.data()['examDateTime'];
    });
  }
}

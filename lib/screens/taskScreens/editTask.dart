import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helper/screens/other/studentHome.dart';

String examTitle = '';
String address = '';
String volunteerId = '';
bool isOnline = false;
bool isSubscribed = false;

class EditTaskPage extends StatefulWidget {
  final String userId, taskId;
  const EditTaskPage({Key? key, required this.userId, required this.taskId}) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {

  late TextEditingController _newExamTitle;
  late TextEditingController _newAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
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
                        Text('Current Exam Title: '),
                        Text(examTitle),
                      ],
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _newExamTitle,
                      decoration: InputDecoration(
                          border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        Text('Current Exam Address: '),
                        Text(address),
                      ],
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _newAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Is the exam online '),
                        SizedBox(width: 10,),
                        Switch(
                          value: isOnline,
                          onChanged: (value) {
                            setState(() {
                              isOnline = value;
                              FirebaseFirestore.instance.collection('Tasks').doc(widget.taskId).update({
                                'isOnline': isOnline
                              });
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          child: Text('Save'),
                          color: Colors.blue,
                          onPressed: () {
                            FirebaseFirestore.instance.collection('Tasks').doc(widget.taskId)
                                .update({
                              'examTitle': _newExamTitle.text.trim(),
                              'address': _newAddress.text.trim(),
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => StudentHomePage()));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
          },
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
      isOnline = ds.data()['isOnline'];
    });

    _newExamTitle = TextEditingController(text:examTitle);
    _newAddress = TextEditingController(text: address);
  }

}

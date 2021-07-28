import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helper/screens/other/studentHome.dart';
import 'package:intl/intl.dart';

String examTitle = '';
String address = '';
String volunteerId = '';
DateTime pickedDate = DateTime.now();
TimeOfDay pickedTime = TimeOfDay.now();
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
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Text('Task ID: '),
                        Text(widget.taskId),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Text('Current Exam Title: '),
                        Text(examTitle),
                      ],
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _newExamTitle,
                      decoration: InputDecoration(
                          border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Text('Current Exam Address: '),
                        Text(address),
                      ],
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: _newAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 15,),
                    ListTile(
                      title: Text('Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}'),
                      trailing: Text('Set Date'),
                      onTap: pickDateDialogue,
                    ),
                    const SizedBox(height: 10,),
                    ListTile(
                      title: Text('Time: ${pickedTime.hour}: ${pickedTime.minute}'),
                      trailing: Text('Set Time'),
                      onTap: pickTimeDialogue,
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          child: Text('Save'),
                          color: Colors.blue,
                          onPressed: () {
                            DateTime examDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
                            DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
                            FirebaseFirestore.instance.collection('Tasks').doc(widget.taskId)
                                .update({
                              'examTitle': _newExamTitle.text.trim(),
                              'address': _newAddress.text.trim(),
                              'examDateTime': dateFormat.format(examDateTime),
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => StudentHomePage()));
                          },
                        ),
                      ],
                    ),
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

  void pickDateDialogue() {
    showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((value) {
      if(value == null){
        return;
      } else {
        setState(() {
          pickedDate = value;
        });
      }
    });
  }

  void pickTimeDialogue() {
    showTimePicker(
        context: context,
        initialTime: pickedTime)
        .then((value) {
      if(value == null){
        return;
      } else {
        setState(() {
          pickedTime = value;
        });
      }
    });
  }
}

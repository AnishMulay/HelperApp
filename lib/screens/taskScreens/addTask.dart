import 'package:flutter/material.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/screens/other/studentHome.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  DateTime pickedDate = DateTime.now();
  TimeOfDay pickedTime = TimeOfDay.now();
  TextEditingController _examTitle =TextEditingController();
  TextEditingController _address =TextEditingController();
  bool isOnline = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task Page'),
      ),
      body: isLoading == false ?
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  TextFormField(
                    controller: _examTitle,
                    decoration: InputDecoration(
                        hintText: 'exam title',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: _address,
                    decoration: InputDecoration(
                        hintText: 'address',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: 30,),
                  ListTile(
                    title: Text('Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}'),
                    trailing: Text('Set Date'),
                    onTap: pickDateDialogue,
                  ),
                  const SizedBox(height: 30,),
                  ListTile(
                    title: Text('Time: ${pickedTime.hour}, ${pickedTime.minute}'),
                    trailing: Text('Set Time'),
                    onTap: pickTimeDialogue,
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Is the exam online', style: TextStyle(fontSize: 20),),
                      SizedBox(width: 17,),
                      Switch(
                        value: isOnline,
                        onChanged: (value) {
                          setState(() {
                            isOnline = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  FlatButton(
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      AuthClass().addTask(
                        examTitle: _examTitle.text.trim(),
                        address: _address.text.trim(),
                        isOnline: isOnline,
                        date: pickedDate,
                        time: pickedTime
                      ).then((value) {
                        if(value == 'Task created'){
                          setState(() {
                            isLoading = false;
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => StudentHomePage()), (route) => false);
                          });
                        }
                      });
                    },
                    child: Text('Create Task'),
                  )
                ],
              ),
            ),
          )
          : Center(
        child: CircularProgressIndicator(),
      )
    );
  }

  void pickDateDialogue() {
    showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)
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

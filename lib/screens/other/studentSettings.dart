import 'package:flutter/material.dart';
import 'package:helper/screens/other/studentHome.dart';
import 'package:helper/screens/other/studentProfile.dart';
import 'package:helper/screens/taskScreens/subscribed.dart';

class StudentSettingsPage extends StatefulWidget {
  const StudentSettingsPage({Key? key}) : super(key: key);

  @override
  _StudentSettingsPageState createState() => _StudentSettingsPageState();
}

class _StudentSettingsPageState extends State<StudentSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Settings'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentHomePage()));
                },
                icon: Icon(Icons.home)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Subscribed()));
                },
                icon: Icon(Icons.beenhere_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentProfilePage()));
                },
                icon: Icon(Icons.person)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentSettingsPage()));
                },
                icon: Icon(Icons.settings)),
          ],
        ),
      ),
    );
  }
}

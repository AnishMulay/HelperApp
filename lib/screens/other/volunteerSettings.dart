import 'package:flutter/material.dart';
import 'package:helper/screens/other/volunteerHome.dart';
import 'package:helper/screens/other/volunteerProfile.dart';
import 'package:helper/screens/taskScreens/volunteered.dart';

class VolunteerSettingsPage extends StatefulWidget {
  const VolunteerSettingsPage({Key? key}) : super(key: key);

  @override
  _VolunteerSettingsPageState createState() => _VolunteerSettingsPageState();
}

class _VolunteerSettingsPageState extends State<VolunteerSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Settings'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerHomePage()));
                },
                icon: Icon(Icons.home)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Volunteered()));
                },
                icon: Icon(Icons.beenhere_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerProfilePage()));
                },
                icon: Icon(Icons.person)),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VolunteerSettingsPage()));
                },
                icon: Icon(Icons.settings)),
          ],
        ),
      ),
    );
  }
}

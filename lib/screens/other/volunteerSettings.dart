import 'package:flutter/material.dart';
import 'package:helper/screens/other/volunteerCompleted.dart';
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
    );
  }
}

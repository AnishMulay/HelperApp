import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helper/screens/other/studentHome.dart';
import 'package:helper/screens/other/studentProfile.dart';
import 'package:helper/screens/taskScreens/subscribed.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userId = '';
String notification = '';

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
    );
  }
}

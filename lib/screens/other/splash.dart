import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helper/screens/authScreens/register.dart';
import 'package:helper/screens/other/studentHome.dart';
import 'package:helper/screens/other/volunteerHome.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String email = '';
String phoneNumber = '';
bool isStudent = false;

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    getUserData();
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 0), () {
      if (auth.currentUser == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => FutureBuilder(
                future: getUserData(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState != ConnectionState.done){
                    return Container();
                  }else{
                    return isStudent == true ?
                    StudentHomePage()
                        : VolunteerHomePage();
                  }
                })), (route) => false);
      }
    });

    return Container();
  }
}

getUserData() async {
  final firebaseUser = auth.currentUser;
  if(firebaseUser != null){
    await FirebaseFirestore.instance.collection('Users')
        .doc(firebaseUser.uid)
        .get()
        .then((ds) {
      email = ds.data()!['displayName'];
      phoneNumber = ds.data()!['phoneNumber'];
      isStudent = ds.data()!['isStudent'];
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String userId = '';
String displayName = '';
String email = '';
String phoneNumber = '';

class ViewVolunteer extends StatefulWidget {
  final String volunteerId;
  const ViewVolunteer({Key? key, required this.volunteerId}) : super(key: key);

  @override
  _ViewVolunteerState createState() => _ViewVolunteerState();
}

class _ViewVolunteerState extends State<ViewVolunteer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Details', style: GoogleFonts.montserrat(fontSize: 18)),
      ),
      body: FutureBuilder(
        future: getUserData(widget.volunteerId),
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Name: ', style: GoogleFonts.montserrat(fontSize: 18)),
                      Text(displayName, style: GoogleFonts.montserrat(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Email: ', style: GoogleFonts.montserrat(fontSize: 18)),
                      Text(email, style: GoogleFonts.montserrat(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Phone Number: ', style: GoogleFonts.montserrat(fontSize: 18)),
                      Text(phoneNumber, style: GoogleFonts.montserrat(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  getUserData(String userId) async {
    await FirebaseFirestore.instance.collection('Users')
        .doc(userId)
        .get()
        .then((ds) {
      displayName = ds.data()['displayName'];
      email = ds.data()['email'];
      phoneNumber = ds.data()['phoneNumber'];
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper/screens/other/studentHome.dart';

String userId = '';
String displayName = '';
String email = '';
String phoneNumber = '';

class EditStudentProfile extends StatefulWidget {
  const EditStudentProfile({Key? key}) : super(key: key);

  @override
  _EditStudentProfileState createState() => _EditStudentProfileState();
}

class _EditStudentProfileState extends State<EditStudentProfile> {

  late TextEditingController _newDisplayName;
  late TextEditingController _newPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student Profile', style: GoogleFonts.montserrat(fontSize: 18),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Display Name: ', style: GoogleFonts.montserrat(fontSize: 18),),
                      ],
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _newDisplayName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Phone Number: ', style: GoogleFonts.montserrat(fontSize: 18)),
                      ],
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _newPhoneNumber,
                      decoration: InputDecoration(
                          border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          child: Text('Save', style: GoogleFonts.montserrat(fontSize: 18)),
                          color: Colors.blueAccent,
                          onPressed: () {
                            FirebaseFirestore.instance.collection('Users').doc(userId)
                                .update({
                              'displayName': _newDisplayName.text.trim(),
                              'phoneNumber': _newPhoneNumber.text.trim()
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

  getUserData() async {
    userId = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('Users')
        .doc(userId)
        .get()
        .then((ds) {
      displayName = ds.data()['displayName'];
      email = ds.data()['email'];
      phoneNumber = ds.data()['phoneNumber'];
    });

    _newDisplayName = TextEditingController(text: displayName);
    _newPhoneNumber = TextEditingController(text: phoneNumber);
  }
}

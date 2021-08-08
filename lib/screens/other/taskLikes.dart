import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper/screens/other/viewVolunteer.dart';

class TaskLikes extends StatefulWidget {
  final String taskId;
  const TaskLikes({Key? key, required this.taskId}) : super(key: key);

  @override
  _TaskLikesState createState() => _TaskLikesState();
}

class _TaskLikesState extends State<TaskLikes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Who has liked this task', style: GoogleFonts.montserrat(fontSize: 18)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Likes')
            .where('studentId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData ?
              ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewVolunteer(volunteerId: ds['volunteerId'])));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('VolunteerId: ',style: GoogleFonts.montserrat(fontSize: 18)),
                                  Text(ds['volunteerId'], style: GoogleFonts.montserrat(fontSize: 18))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }) :
              Center(
                child: CircularProgressIndicator(),
              );
        },
      ),
    );
  }

}

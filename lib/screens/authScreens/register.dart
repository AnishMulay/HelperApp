import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/screens/other/splash.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _displayName = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  bool isLoading = false;
  bool isStudent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: normal,),
      ),
      body: isLoading == false ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text('Welcome to Ekatvam, please provide the details given below to create an account and get started', style: normal),
              const SizedBox(height: 40,),
              Text('Email', style: normal),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 40,),
              Text('Password', style: normal),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 40,),
              Text('Full Name', style: normal),
              TextFormField(
                controller: _displayName,
                decoration: InputDecoration(
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 40,),
              Text('Phone Number', style: normal),
              TextFormField(
                controller: _phoneNumber,
                decoration: InputDecoration(
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30,),
              FlatButton(
                  color: Colors.blueAccent,
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    AuthClass().createAccount(
                        email: _email.text.trim(),
                        password: _password.text.trim()
                    ).then((value) {
                      if(value == 'Account created'){
                        AuthClass().addUser(
                          email: _email.text.trim(),
                          displayName: _displayName.text.trim(),
                          phoneNumber: _phoneNumber.text.trim(),
                          isStudent: true
                        ).then((value) {
                          if(value == 'User added'){
                            setState(() {
                              isLoading = false;
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => Splash()), (route) => false);
                            });
                          }
                        });
                      }
                      else{
                        if(value != null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('NULL')));
                        }
                      }
                    });
                  }, child: Text('Register as a Student', style: normal,)),
              FlatButton(
                  color: Colors.blueAccent,
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    AuthClass().createAccount(
                        email: _email.text.trim(),
                        password: _password.text.trim()
                    ).then((value) {
                      if(value == 'Account created'){
                        AuthClass().addUser(
                            email: _email.text.trim(),
                            displayName: _displayName.text.trim(),
                            phoneNumber: _phoneNumber.text.trim(),
                            isStudent: isStudent
                        ).then((value) {
                          if(value == 'User added'){
                            setState(() {
                              isLoading = false;
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => Splash()), (route) => false);
                            });
                          }
                        });
                      }
                      else{
                        if(value != null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('NULL')));
                        }
                      }
                    });
                  }, child: Text('Register as a Volunteer', style: normal,)),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                    'Already have an account ?',
                  style: normal,
                ),
              ),
              const SizedBox(height: 30,),
            ],
          ),
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}

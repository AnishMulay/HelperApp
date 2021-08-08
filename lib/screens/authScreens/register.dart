import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper/providers/auth_provider.dart';
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
        title: Text('Register', style: GoogleFonts.montserrat(fontSize: 18),),
      ),
      body: isLoading == false ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    hintStyle: GoogleFonts.montserrat(fontSize: 18),
                    hintText: 'email',
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30,),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                    hintStyle: GoogleFonts.montserrat(fontSize: 18),
                    hintText: 'Password',
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30,),
              TextFormField(
                controller: _displayName,
                decoration: InputDecoration(
                    hintStyle: GoogleFonts.montserrat(fontSize: 18),
                    hintText: 'Full Name',
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30,),
              TextFormField(
                controller: _phoneNumber,
                decoration: InputDecoration(
                    hintStyle: GoogleFonts.montserrat(fontSize: 18),
                    hintText: 'Phone Number',
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Are you a student', style: GoogleFonts.montserrat(fontSize: 18),),
                  SizedBox(width: 17,),
                  Switch(
                    value: isStudent,
                    onChanged: (value) {
                      setState(() {
                        isStudent = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20,),
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
                  }, child: Text('Create Account', style: GoogleFonts.montserrat(fontSize: 18),)),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                    'Already have an account ?',
                  style: GoogleFonts.montserrat(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}

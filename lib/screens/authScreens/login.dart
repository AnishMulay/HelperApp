import 'package:flutter/material.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/screens/authScreens/register.dart';
import 'package:helper/screens/authScreens/reset.dart';
import 'package:helper/screens/other/splash.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: GoogleFonts.montserrat(fontSize: 18),),
      ),
      body: isLoading == false ? Padding(
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
            FlatButton(
                color: Colors.blueAccent,
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  AuthClass().signIn(
                      email: _email.text.trim(),
                      password: _password.text.trim()
                  ).then((value) {
                    if(value == 'Welcome'){
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Splash()), (route) => false);
                    }else{
                      setState(() {
                        isLoading = false;
                      });
                      if(value != null){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('NULL')));
                      }
                    }
                  });
                }, child: Text('Login', style: GoogleFonts.montserrat(fontSize: 18))),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Text(
                  "Don't have an account ?",
                  style: GoogleFonts.montserrat(fontSize: 18)
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResetPage()));
              },
              child: Text(
                  'Forgot Password ?',
                  style: GoogleFonts.montserrat(fontSize: 18)
              ),
            ),
          ],
        ),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}

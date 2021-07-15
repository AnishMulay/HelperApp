import 'package:flutter/material.dart';
import 'package:helper/providers/auth_provider.dart';
import 'package:helper/screens/authScreens/register.dart';
import 'package:helper/screens/authScreens/reset.dart';
import 'package:helper/screens/other/splash.dart';

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
        title: Text('Login'),
      ),
      body: isLoading == false ? Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                  hintText: 'email',
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 30,),
            TextFormField(
              controller: _password,
              decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 30,),
            FlatButton(
                color: Colors.blue,
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
                }, child: Text('Login')),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Text(
                  "Don't have an account ?",
                style: TextStyle(
                  fontSize: 17
                ),
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPage()));
              },
              child: Text(
                  'Forgot Password ?',
                style: TextStyle(
                  fontSize: 17
                ),
              ),
            ),
          ],
        ),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}

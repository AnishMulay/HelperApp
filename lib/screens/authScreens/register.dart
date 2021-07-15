import 'package:flutter/material.dart';
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
        title: Text('Register'),
      ),
      body: isLoading == false ? SingleChildScrollView(
        child: Padding(
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
              TextFormField(
                controller: _displayName,
                decoration: InputDecoration(
                    hintText: 'Display Name',
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30,),
              TextFormField(
                controller: _phoneNumber,
                decoration: InputDecoration(
                    hintText: 'Phone Number',
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Are you a student', style: TextStyle(fontSize: 20),),
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
              const SizedBox(height: 30,),
              FlatButton(
                  color: Colors.blue,
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
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('NULL')));
                        }
                      }
                    });
                  }, child: Text('Create Account')),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                    'Already have an account ?',
                  style: TextStyle(
                    fontSize: 17
                  ),
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

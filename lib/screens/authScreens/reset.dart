import 'package:flutter/material.dart';
import 'package:helper/providers/auth_provider.dart';

import 'login.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({Key? key}) : super(key: key);

  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {

  TextEditingController _email = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset'),
      ),
      body: isLoading == false ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                  hintText: 'email'
              ),
            ),
            const SizedBox(height: 30,),
            FlatButton(
                color: Colors.blue,
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  AuthClass().resetPassword(
                    email: _email.text.trim()
                  ).then((value) {
                    if(value == 'Email sent'){
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
                    }
                  });
                }, child: Text('Reset Password')),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text('Already have an account ?'),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}

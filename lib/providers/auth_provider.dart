//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthClass {

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> createAccount({String email, String password}) async {
    try {
      print('register started');
      await auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return 'Account created';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return 'Welcome';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
  }

  Future<String> resetPassword({String email}) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email,
      );
      return 'Email sent';
    }catch(e){
      return 'Error';
    }
  }

  void signOut() {
    auth.signOut();
  }

  Future<String> addUser({String displayName, String phoneNumber, bool isStudent}) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('Users');
      String uid = auth.currentUser.uid.toString();
      users.add({
        'uid': uid,
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'isStudent': isStudent
      });
      return 'User added';
    } catch (e) {
      return 'Error';
    }
  }


}
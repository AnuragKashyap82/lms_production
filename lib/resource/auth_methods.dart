import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String> loginUser({
  required String email,
  required String password,
}) async {
  String res = "No user found";
  try {
    if (email.isNotEmpty &&
        password.isNotEmpty){
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "Success";
    }else{
      res = "Please enter all the fields";
    }

  } on FirebaseAuthException catch (e) {
    if (e.code == "invalid-email") {
      res = "The email is badly formatted";
    } else if (e.code == "wrong-password") {
      res = "The password is Incorrect";
    }else if (e.code == "weak-password") {
      res = "The password is weak 6 characters must";
    }
  }
  catch (err) {
    res = err.toString();
  }
  return res;
}

Future<String> signUpUser({
  required String email,
  required String password,
  required String cPassword,
  required String studentId,
  required String userType,
  required String name,
}) async {
  String res = "Some Error Occured";
  try {
    if (email.isNotEmpty &&
        password.isNotEmpty &&
        name.isNotEmpty &&
        cPassword == password) {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);


      Map<String,dynamic> data = {
        "name": name,
        "uid": cred.user!.uid,
        "email": email,  // Updating Document Reference
        "studentId": studentId,  // Updating Document Reference
        "photoUrl": "", // Updating Document Reference
        'completeAddress':"", // Updating Document Reference
        'dob': "", // Updating Document Reference
        'regNo': "", // Updating Document Reference
        'branch': "", // Updating Document Reference
        'semester': "", // Updating Document Reference
        'session': "", // Updating Document Reference
        'seatType': "",// Updating Document Reference
        'userType': userType,// Updating Document Reference
      };
      await _firestore.collection("users").doc(cred.user!.uid).set(data).whenComplete((){

      });

      res = "Success";
    }
  } on FirebaseAuthException catch (err) {
    if (err.code == "invalid-email") {
      res = "The email is badly formatted";
    } else if (err.code == "weak-password") {
      res = "The password is weak 6 characters must";
    }
  } catch (err) {
    res = err.toString();
    print(err.toString());
  }
  return res;
}

}
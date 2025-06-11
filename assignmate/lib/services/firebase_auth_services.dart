import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final user = FirebaseAuth.instance.currentUser;

    if (fcmToken != null) {
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(user?.uid)
          .update({
        'fcmToken': fcmToken,
      });
    }
  }

  Future<void> signUpUser(
      {required String role,
      required email,
      required password,
      required userName,
      required repId}) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Please enter both email and password");
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String collection = (role == "rep" ? 'Class_Rep' : 'Students');

        await _firestore
            .collection(collection)
            .doc(userCredential.user!.uid)
            .set({
          "email": email,
          "userName": userName,
          "repId": repId ?? "N/A",
          "role": role,
        }, SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Sign up failed. Please try again.");
    }
  }

  Future<UserCredential?> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Please enter both email and password");
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed. Please try again.");
    }
  }

  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot repDoc =
        await _firestore.collection('Class_Rep').doc(uid).get();
    DocumentSnapshot userDoc =
        await _firestore.collection('Students').doc(uid).get();

    if (repDoc.exists) {
      return "rep";
    } else if (userDoc.exists) {
      return "student";
    }
    return null;
  }

  Future<bool> checkIfRepExists() async {
    try {
      var querySnapshot = await _firestore
          .collection("Class_Rep")
          .where("role", isEqualTo: "rep")
          .get();

      return querySnapshot.docs.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

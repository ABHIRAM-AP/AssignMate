import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Future<bool> getAdmin() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    DocumentSnapshot adminDoc =
        await FirebaseFirestore.instance.collection('admin').doc(uid).get();

    if (adminDoc.exists) {
      return adminDoc['role'] == 'admin';
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

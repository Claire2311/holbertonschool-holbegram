import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';

class AuthMethode {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<String> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return "Please fill all the fields";
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // if (context.mounted) {
      //   // to avoid error with context and async function
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const HomePage()),
      //   );
      // }
      return "success";
    } on FirebaseAuthException catch (e) {
      return "Wrong credentials";
    }
  }

  Future<String> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      return "Please fill all the fields";
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final storageMethods = StorageMethods();
      String imageUrl = '';

      if (file != null) {
        imageUrl = await storageMethods.uploadImageToStorage(
          false,
          'profilePictures',
          file,
        );
      }

      Users user = Users(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
        bio: "",
        followers: [],
        following: [],
        photoUrl: imageUrl,
        posts: [],
        saved: [],
        searchKey: '',
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toJson());

      // if (context.mounted) {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const HomePage()), 🚨🚨🚨🚨🚨🚨🚨🚨
      //   );
      // }
      return "success";
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "An error occurred"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return e.message ?? "An error occurred";
    }
  }

  Future<Users?> getCurrentUserDetails() async {
    if (_auth.currentUser == null) {
      return null;
    }

    String userId = _auth.currentUser!.uid;

    try {
      final docSnap = await _firestore.collection("users").doc(userId).get();

      if (docSnap.exists && docSnap.data() != null) {
        return Users.fromJson(docSnap);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

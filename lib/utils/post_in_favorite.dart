import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holbegram/models/favorite_model.dart';

class FavoritePosts {
  final _firestore = FirebaseFirestore.instance;

  Future<String> putPostInFavorite(
    String userId,
    String postId,
    String postUrl,
  ) async {
    try {
      FavoriteModel favoritePost = FavoriteModel(
        userId: userId,
        postId: postId,
        postUrl: postUrl,
        dateInFavorite: DateTime.now(),
      );

      await _firestore
          .collection('FavoritePosts')
          .doc()
          .set(favoritePost.toJson());

      return "Ok";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    }
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holbegram/models/favorite_model.dart';

class FavoritePosts {
  final _firestore = FirebaseFirestore.instance;

  Future<String> getPostInFavorite(
    String userId,
    String postId,
    String postUrl,
  ) async {
    try {
      FavoriteModel favoritePost = FavoriteModel(
        userId: userId,
        postId: postId,
        postUrl: postUrl,
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

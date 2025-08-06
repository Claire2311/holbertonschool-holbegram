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

      await _firestore
          .collection('posts')
          .doc(postId) // Utiliser directement l'ID
          .update({
            'likes': FieldValue.arrayUnion([userId]),
          });

      return "Ok";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    }
  }

  Future<String> removePostFromFavorite(
    String userId,
    String postId,
    String postUrl,
  ) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('FavoritePosts')
          .where('postId', isEqualTo: postId)
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
      }

      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([userId]),
      });

      return "Ok";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    }
  }
}

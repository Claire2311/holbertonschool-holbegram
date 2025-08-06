import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import 'package:holbegram/models/posts.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';

class PostStorage {
  final _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String username,
    String profImage,
    Uint8List image,
    String userId,
  ) async {
    try {
      final storageMethods = StorageMethods();
      String imageUrl = '';

      if (image != null) {
        imageUrl = await storageMethods.uploadImageToStorage(
          true,
          'postImages',
          image,
        );
      }

      final publicationDate = DateTime.now();
      var uuid = Uuid();
      final postId = uuid.v4();

      Post post = Post(
        uid: postId,
        username: username,
        caption: caption,
        profImage: profImage,
        postUrl: imageUrl,
        datePublished: publicationDate,
        postId: postId,
        likes: [],
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());

      await _firestore.collection('users').doc(userId).update({
        'posts': FieldValue.arrayUnion([postId]),
      });

      return "Ok";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    }
  }

  Future<String> deletePost(
    String postId,
    String userId,
    String? publicId,
  ) async {
    try {
      if (publicId != null && publicId.isNotEmpty) {
        final storageMethods = StorageMethods();
        await storageMethods.deleteImageFromStorage(publicId);
      }

      await _firestore.collection('posts').doc(postId).delete();

      await _firestore.collection('users').doc(userId).update({
        'posts': FieldValue.arrayRemove([postId]),
      });

      QuerySnapshot querySnapshot = await _firestore
          .collection('FavoritePosts')
          .where('postId', isEqualTo: postId)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await _firestore.collection('FavoritePosts').doc(doc.id).delete();
      }

      return "Post deleted";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    }
  }
}

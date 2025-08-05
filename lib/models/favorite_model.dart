import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  String userId;
  String postId;
  String postUrl;

  FavoriteModel({
    required this.userId,
    required this.postId,
    required this.postUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (postId != null) 'postId': postId,
      if (postUrl != null) 'postUrl': postUrl,
    };
  }

  static FavoriteModel fromJson(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>?;
    return FavoriteModel(
      userId: snapshot?['userId'],
      postId: snapshot?['postId'],
      postUrl: snapshot?['postUrl'],
    );
  }
}

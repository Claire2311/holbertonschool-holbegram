import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? caption;
  String? uid;
  String? username;
  List? likes;
  String? postId;
  DateTime? datePublished;
  String? postUrl;
  String? profImage;

  Post({
    this.caption,
    this.uid,
    this.username,
    this.likes,
    this.postId,
    this.datePublished,
    this.postUrl,
    this.profImage,
  });

  Map<String, dynamic> toJson() {
    return {
      if (uid != null) 'uid': uid,
      if (caption != null) 'caption': caption,
      if (username != null) 'username': username,
      if (likes != null) 'likes': likes,
      if (postId != null) 'postId': postId,
      if (datePublished != null) 'datePublished': datePublished,
      if (postUrl != null) 'postUrl': postUrl,
      if (profImage != null) 'profImage': profImage,
    };
  }

  static Post fromJson(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>?;
    return Post(
      uid: snapshot?['uid'],
      caption: snapshot?['caption'],
      username: snapshot?['username'],
      likes: snapshot?['likes'],
      postId: snapshot?['postId'],
      datePublished: snapshot?['datePublished'],
      postUrl: snapshot?['postUrl'],
      profImage: snapshot?['profImage'],
    );
  }
}

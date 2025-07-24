import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holbegram/models/posts.dart';

class Users {
  String? uid;
  String? email;
  String? username;
  String? bio;
  String? photoUrl;
  List<dynamic>? followers;
  List<dynamic>? following;
  List<Post>? posts;
  List<dynamic>? saved;
  String? searchKey;

  Users({
    this.uid,
    this.email,
    this.username,
    this.bio,
    this.photoUrl,
    this.followers,
    this.following,
    this.posts,
    this.saved,
    this.searchKey,
  });

  Map<String, dynamic> toJson() {
    return {
      if (uid != null) 'uid': uid,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
      if (bio != null) 'bio': bio,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (followers != null) 'followers': followers,
      if (following != null) 'following': following,
      if (posts != null) 'posts': posts?.map((post) => post.toJson()).toList(),
      if (saved != null) 'saved': saved,
      if (searchKey != null) 'searchKey': searchKey,
    };
  }

  static Users fromJson(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>?;
    return Users(
      uid: snapshot?['uid'],
      email: snapshot?['email'],
      username: snapshot?['username'],
      bio: snapshot?['bio'],
      photoUrl: snapshot?['photoUrl'],
      followers: snapshot?['followers'],
      following: snapshot?['following'],
      posts: snapshot?['posts'] != null
          ? (snapshot!['posts'] as List)
                .map((post) => Post.fromJson(post))
                .toList()
          : null,
      saved: snapshot?['saved'],
      searchKey: snapshot?['searchKey'],
    );
  }
}

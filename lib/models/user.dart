import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Users {
  String? uid;
  String? email;
  String? username;
  String? bio;
  String? photoUrl;
  List<dynamic>? followers;
  List<dynamic>? following;
  List<dynamic>? posts;
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

  static fromJson(dynamic data) {
    return Users(
      uid: data['uid'],
      email: data['email'],
      username: data['username'],
      bio: data['bio'],
      photoUrl: data['photoUrl'],
      followers: data['followers'],
      following: data['following'],
      posts: data['posts'],
      saved: data['saved'],
      searchKey: data['searchKey'],
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'username': username,
    'bio': bio,
    'photoUrl': photoUrl,
    'followers': followers,
    'following': following,
    'posts': posts,
    'saved': saved,
    'searchKey': searchKey,
  };
}

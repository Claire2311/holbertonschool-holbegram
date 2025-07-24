import 'package:flutter/material.dart';
import 'package:holbegram/models/posts.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/methods/auth_methods.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final AuthMethode _authMethode = AuthMethode();
  Users? user;
  List<Post>? userPosts;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    Users? userData = await _authMethode.getUserDetails();
    setState(() {
      user = userData;
      if (user != null && user!.posts != null) {
        userPosts = user!.posts!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

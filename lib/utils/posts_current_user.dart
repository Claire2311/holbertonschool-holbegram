import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/models/posts.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/screens/Pages/methods/post_storage.dart';
import 'package:holbegram/utils/post_in_favorite.dart';

class PostsCurrentUser extends StatefulWidget {
  const PostsCurrentUser({super.key});

  @override
  State<PostsCurrentUser> createState() => _PostsCurrentUserState();
}

class _PostsCurrentUserState extends State<PostsCurrentUser> {
  final _firestore = FirebaseFirestore.instance;
  final AuthMethode _authMethode = AuthMethode();
  // Users? user;
  List<Post>? userPosts;

  @override
  void initState() {
    super.initState();
    _getCurrentUserPosts();
  }

  void _getCurrentUserPosts() async {
    Users? currentUser = await _authMethode.getCurrentUserDetails();

    if (currentUser?.posts != null && currentUser!.posts!.isNotEmpty) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .where('uid', whereIn: currentUser.posts!)
          .get();

      List<Post> currentUserPosts = querySnapshot.docs
          .map((doc) => Post.fromJson(doc))
          .toList();

      setState(() {
        userPosts = currentUserPosts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userPosts == null
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 1.0, // Square grid items
            ),
            itemCount: userPosts!.length,
            itemBuilder: (context, index) {
              Post post = userPosts![index];

              return GestureDetector(
                onTap: () {
                  // Navigate to post detail or open image viewer
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    child: Image.network(
                      post.postUrl ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, size: 32),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
  }
}

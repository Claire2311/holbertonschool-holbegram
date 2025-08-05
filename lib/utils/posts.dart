import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/models/posts.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/screens/Pages/methods/post_storage.dart';
import 'package:holbegram/utils/post_in_favorite.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final AuthMethode _authMethode = AuthMethode();
  Users? user;
  List<Post>? userPosts;
  final PostStorage _postStorage = PostStorage();
  final FavoritePosts _favoritePosts = FavoritePosts();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    Users? currentUser = await _authMethode.getCurrentUserDetails();
    setState(() {
      user = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Center(child: CircularProgressIndicator());
        // }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        //   return Center(child: Text('Aucun document disponible'));
        // }

        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsetsGeometry.lerp(
                    const EdgeInsets.all(8),
                    const EdgeInsets.all(8),
                    10,
                  ),
                  height: 540,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(data['profImage']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Text(data['username']),
                          Spacer(),
                          IconButton(
                            onPressed: () async {
                              final response = await _postStorage.deletePost(
                                data['postId'],
                                data['publicId'],
                              );
                              if (response == "Post deleted") {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Post deleted"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: $response"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },

                            icon: Icon(Icons.more_horiz),
                          ),
                        ],
                      ),
                      SizedBox(child: Text(data['caption'])),
                      SizedBox(height: 10),
                      Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: NetworkImage(data['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 35.0,
                          top: 12.0,
                          bottom: 12.0,
                        ),
                        child: Row(
                          spacing: 20.0,
                          children: [
                            IconButton(
                              onPressed: () {
                                _favoritePosts.putPostInFavorite(
                                  user!.uid!,
                                  data['uid'],
                                  data['postUrl'],
                                );
                              },
                              icon: Icon(Icons.favorite_border),
                            ),
                            Icon(Icons.chat_bubble_outline_outlined),
                            Icon(Icons.share),
                            Container(
                              alignment: Alignment.topRight,
                              child: Icon(Icons.bookmark_border),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/screens/login_screen.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/utils/posts_current_user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthMethode _authMethode = AuthMethode();
  Users? user;
  String? username;
  String? profilePicture;
  String? numOfPosts;
  String? numOfFollowers;
  String? numOfFollowings;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    Users? currentUser = await _authMethode.getCurrentUserDetails();
    setState(() {
      user = currentUser;
      username = currentUser?.username ?? '';
      if (currentUser?.photoUrl == null || currentUser?.photoUrl == '') {
        profilePicture =
            'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';
      } else {
        profilePicture = currentUser?.photoUrl;
      }
      numOfPosts = ((currentUser?.posts?.length) ?? 0).toString();
      numOfFollowers = ((currentUser?.followers?.length) ?? 0).toString();
      numOfFollowings = ((currentUser?.following?.length) ?? 0).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/logo.webp'),
        title: Text(
          "Profile",
          style: TextStyle(fontFamily: "Billabong", fontSize: 40),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              spacing: 10,
              children: [
                IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
          ),
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(profilePicture!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            username!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            numOfPosts!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text("posts", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            numOfFollowers!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "followers",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            numOfFollowings!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "following",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                Expanded(child: PostsCurrentUser()),
              ],
            ),
    );
  }
}

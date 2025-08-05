import 'package:flutter/material.dart';
import 'package:holbegram/utils/posts.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/logo.webp'),
        title: Text(
          "Holbegram",
          style: TextStyle(fontFamily: "Billabong", fontSize: 40),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              spacing: 10,
              children: [
                Icon(Icons.add),
                Icon(Icons.chat_bubble_outline_outlined),
              ],
            ),
          ),
        ],
      ),
      body: Posts(),
    );
  }
}

import 'package:flutter/material.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Holbegram", style: TextStyle(fontFamily: "Billabong")),
        leading: Image.asset('assets/images/logo.webp'),
        actions: [
          Row(
            children: [
              Icon(Icons.add),
              Icon(Icons.chat_bubble_outline_outlined),
            ],
          ),
        ],
      ),
      // body: Posts(), 🚨🚨🚨🚨🚨🚨
    );
  }
}

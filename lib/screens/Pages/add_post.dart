import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/screens/Pages/methods/post_storage.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:holbegram/screens/home.dart';

class AddImage extends StatefulWidget {
  final TextEditingController? captionController;
  const AddImage({super.key, this.captionController});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final TextEditingController _captionController = TextEditingController();
  Uint8List? _image;
  final _picker = ImagePicker();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void selectImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _image = await File(pickedImage.path).readAsBytes();
      setState(() {}); // Trigger rebuild to show the image
    }
  }

  void selectImageFromCamera() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      _image = await File(pickedImage.path).readAsBytes();
      setState(() {}); // Trigger rebuild to show the image
    }
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              selectImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              selectImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Post", style: TextStyle(fontSize: 40)),
        actions: [
          TextButton(
            onPressed: () async {
              // Check if image is selected before proceeding
              if (_image == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please select an image first"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              var authMethods = AuthMethode();
              var currentUserDetails = await authMethods
                  .getCurrentUserDetails();
              if (currentUserDetails != null) {
                var postStorage = PostStorage();

                try {
                  String result = await postStorage.uploadPost(
                    _captionController.text.trim(),
                    currentUserDetails.username!,
                    currentUserDetails.photoUrl ?? '',
                    _image!,
                    currentUserDetails.uid!,
                  );

                  if (result == "Ok") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Post uploaded successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ), // cause mistake ?
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $result"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to upload post"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(
              "Post",
              style: TextStyle(
                fontFamily: "Billabong",
                fontSize: 30,
                color: Color.fromARGB(218, 226, 37, 24),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100),
              Text(
                'Add Image',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              Text(
                'Choose an image from your gallery or take a new one',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _captionController,
                decoration: InputDecoration(
                  labelText: "Write a caption...",
                  border: InputBorder.none, // Supprime toutes les bordures
                  enabledBorder: InputBorder
                      .none, // Supprime la bordure quand le champ n'est pas focalisé
                  focusedBorder: InputBorder
                      .none, // Supprime la bordure quand le champ est focalisé
                ),
              ),
              SizedBox(height: 50),
              _image != null
                  ? CircleAvatar(
                      radius: 100,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : IconButton(
                      onPressed: showOptions, // 🚨 choose picture
                      icon: Image.network(
                        "https://cdn.pixabay.com/photo/2017/11/10/05/24/add-2935429_960_720.png",
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

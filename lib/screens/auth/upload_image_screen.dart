import 'dart:io';
import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final Uint8List? _image;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
    Uint8List? image,
  }) : _image = image;

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  late Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _image = widget._image;
  }

  final _picker = ImagePicker();

  void selectImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _image = await File(pickedImage.path).readAsBytes();
      setState(() {});
    }
  }

  void selectImageFromCamera() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      _image = await File(pickedImage.path).readAsBytes();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              'Holbegram',
              style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
            ),
            Image.asset('assets/images/logo.webp', width: 80, height: 60),
            SizedBox(height: 50),
            Text(
              'Hello, ${widget.username} Welcome to Holbegram.',
              style: TextStyle(fontSize: 20),
            ),
            Text("Choose an image from your gallery or take a new one."),
            SizedBox(height: 50),
            _image != null
                ? CircleAvatar(
                    radius: 100,
                    backgroundImage: MemoryImage(_image!),
                  )
                : const CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                    ),
                  ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 50,
                  onPressed: selectImageFromGallery,
                  icon: Icon(Icons.image_outlined),
                  color: Color.fromARGB(218, 226, 37, 24),
                ),
                IconButton(
                  iconSize: 50,
                  onPressed: selectImageFromCamera,
                  icon: Icon(Icons.camera_alt_outlined),
                  color: Color.fromARGB(218, 226, 37, 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Color.fromARGB(218, 226, 37, 24),
                ),
              ),
              onPressed: () async {
                AuthMethode authMethode = AuthMethode();
                String result = await authMethode.signUpUser(
                  context: context,
                  email: widget.email,
                  password: widget.password,
                  username: widget.username,
                  file: _image,
                );
                // Handle the result here
                if (result == "success") {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Success"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  // Show error message
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(result)));
                  }
                }
              },
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

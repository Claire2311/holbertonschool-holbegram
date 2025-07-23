import 'dart:io';

import 'package:flutter/material.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              'Holbegram',
              style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
            ),
            Image.asset('assets/images/logo.webp', width: 80, height: 60),
            Text(
              'Hello, ${widget.username} Welcome to Holbegram.',
              style: TextStyle(fontSize: 20),
            ),
            Text("Choose an image from your gallery or take a new one."),
            _image != null
                ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                    ),
                  ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: selectImageFromGallery,
                  icon: Icon(Icons.image_outlined),
                  color: Color.fromARGB(218, 226, 37, 24),
                ),
                IconButton(
                  onPressed: selectImageFromCamera,
                  icon: Icon(Icons.camera_alt_outlined),
                  color: Color.fromARGB(218, 226, 37, 24),
                ),
                // ElevatedButton(
                //   onPressed: selectImageFromGallery,
                //   child: const Text('Gallery'),
                // ),
                // ElevatedButton(
                //   onPressed: selectImageFromCamera,
                //   child: const Text('Camera'),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text("Next")),
          ],
        ),
      ),
    );
  }
}

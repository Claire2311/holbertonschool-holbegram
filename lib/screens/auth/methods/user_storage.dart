import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StorageMethods {
  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  String get cloudinaryUrl =>
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload";
  final String cloudinaryPreset = "holbegrampreset";

  Future<String> uploadImageToStorage(
    bool isPost,
    String childName,
    Uint8List file,
  ) async {
    String uniqueId = const Uuid().v1();
    var uri = Uri.parse(cloudinaryUrl);
    var request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = cloudinaryPreset;
    request.fields['folder'] = childName;
    // request.fields['public_id'] = isPost ? uniqueId : '';
    request.fields['public_id'] = uniqueId;

    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      file,
      filename: '$uniqueId.jpg',
    );
    request.files.add(multipartFile);

    var response = await request.send();
    // ci-dessous utilisé pour avoir le message d'erreur
    // var responseData = await response.stream.toBytes();
    // var jsonResponse = jsonDecode(String.fromCharCodes(responseData));
    // print(jsonResponse);
    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var jsonResponse = jsonDecode(String.fromCharCodes(responseData));
      return jsonResponse['secure_url'];
    } else {
      throw Exception('Failed to upload image to Cloudinary');
    }
  }
}

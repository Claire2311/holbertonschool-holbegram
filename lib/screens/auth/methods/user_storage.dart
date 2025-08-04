import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

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

  Future<String> deleteImageFromStorage(String publicId) async {
    try {
      // URL pour la suppression (destroy endpoint)
      String destroyUrl =
          "https://api.cloudinary.com/v1_1/$cloudName/image/destroy";
      var uri = Uri.parse(destroyUrl);

      String apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
      String apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? '';
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Génération de la signature SHA1
      String stringToSign =
          'public_id=$publicId&timestamp=$timestamp$apiSecret';
      var bytes = utf8.encode(stringToSign);
      var digest = sha1.convert(bytes);
      String signature = digest.toString();

      var request = http.MultipartRequest('POST', uri);
      request.fields['api_key'] = apiKey;
      request.fields['public_id'] = publicId;
      request.fields['timestamp'] = timestamp;
      request.fields['signature'] = signature;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var jsonResponse = jsonDecode(String.fromCharCodes(responseData));

        if (jsonResponse['result'] == 'ok') {
          return "Image deleted successfully";
        } else {
          return "Failed to delete image: ${jsonResponse['result']}";
        }
      } else {
        return "Failed to delete image: HTTP ${response.statusCode}";
      }
    } catch (e) {
      return "Error deleting image: ${e.toString()}";
    }
  }
}

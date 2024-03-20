import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ImageApi {

  String apiUrl = "http://10.0.2.2:3000";

  Future<void> uploadImage(String base64Image) async {
    final url =  '$apiUrl/upload';
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-16',
    };
    final body = jsonEncode({'base64Image': base64Image});

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      debugPrint('Image uploaded successfully');
    } else {
      debugPrint('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  Future<void> getImage(String filename) async {
    final url = '$apiUrl/image/$filename';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // skal laves: 
      // send til display
      debugPrint('Image received');
    } else {
      debugPrint('Failed to get image. Status code: ${response.statusCode}');
    }
  }
}

// lib/providers/cloudinary_provider.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CloudinaryProvider with ChangeNotifier {
  final String _cloudName = 'dppa2vheu';
  final String _uploadPreset = 'Article'; // Set up an unsigned upload preset in Cloudinary

  String _imageUrl = '';
  String _currentType = '';
  Uint8List? _imageData;
  Uint8List? _luchImageData;
  Uint8List? _snackImageData;
  Uint8List? _dinnerImageData;


  String get imageUrl => _imageUrl;
  String get currentType => _currentType;
  Uint8List? get imageData => _imageData;
  Uint8List? get luchImageData => _luchImageData;
  Uint8List? get snackImageData => _snackImageData;
  Uint8List? get dinnerImageData => _dinnerImageData;


  void setCurrentType(String type) {
    _currentType = type;
    notifyListeners();
  }

  //to display image in container
  void setImageData(Uint8List data) {
    _imageData = data;
    _luchImageData = data;
    _snackImageData = data;
    _dinnerImageData = data;
    notifyListeners();
  }

  // clear image
  void clearImage() {
    _imageData = null;
    _luchImageData = null;
    _snackImageData = null;
    _dinnerImageData = null;

    notifyListeners();
  }

  Future<void> uploadImage(Uint8List imageBytes) async {
   //cloud name
    const String cloudName = 'dppa2vheu';
    //folder name
    const String uploadPreset = 'Article';
    const String folderName = 'images'; // Specify the folder
// signed preset

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..fields['folder'] = folderName // Add the folder parameter
      ..files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));

    try {
      final response = await request.send();
      log("Status Code:: ${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        _imageUrl = jsonResponse['secure_url'];
        log("Image Url:: ${jsonResponse['secure_url']}");

        notifyListeners(); // Notify listeners about the change
      } else {
        final responseBody = await response.stream.bytesToString();
        log("Response Body:: ${responseBody}");
        throw Exception('Failed to upload image: $responseBody');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }}
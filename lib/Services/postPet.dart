import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';  // for jsonDecode

Future<void> uploadPetDetailsAndMedia(
    String petName,
    String petType,
    int petAge,
    double petPrice,
    String petDescription,
    String petGender,
    List<XFile> mediaFiles,
    ) async {
  final cloudinaryUrl = Uri.parse("https://api.cloudinary.com/v1_1/dwxd6ynem/upload");

  try {
    final firestore = FirebaseFirestore.instance;

    List<String> mediaUrls = [];

    for (XFile file in mediaFiles) {
      final bytes = await file.readAsBytes();
      final fileName = basename(file.path);

      var request = http.MultipartRequest('POST', cloudinaryUrl);
      request.fields['upload_preset'] = 'petsStore';
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Cloudinary Response: $responseData');

        final data = jsonDecode(responseData);
        final mediaUrl = data['secure_url'];

        mediaUrls.add(mediaUrl);
      } else {
        print("Error uploading image to Cloudinary: ${response.statusCode}");
        final responseData = await response.stream.bytesToString();
        print("Response body: $responseData");
      }
    }
    final currentUser =  await FirebaseAuth.instance.currentUser;
    await firestore.collection('pets').add({
      "sellerID": currentUser?.email.toString(),
      'petName': petName,
      'petType': petType,
      'petAge': petAge,
      'petPrice': petPrice,
      'mediaUrls': mediaUrls,
      'createdAt': Timestamp.now(),
      'petGender': petGender,
      'petDescription': petDescription,
      'postStatus': "Active"
    });

    print("Pet details and media uploaded successfully!");
  } catch (e) {
    print("Error occurred while uploading: $e");
  }
}

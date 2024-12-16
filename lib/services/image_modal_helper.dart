import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image/image.dart' as img; // Import image package

class ImageModalService {
  final FlutterSecureStorage storage = FlutterSecureStorage();  // Initialize the storage

  /// Saves the image, label, confidence, and userId to Firebase Firestore.
  Future<void> saveToFirebase(String label, String confidence, File imageFile) async {
    try {
      print(label);

      // Fetch the userId from storage
      final userId = await storage.read(key: 'userId');

      // Compress the image
      final img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;
      final img.Image resizedImage = img.copyResize(image, width: 800);  // Resize the image to 800px width (adjust as needed)

      // Convert compressed image to bytes and then to Base64
      final List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 85);  // Compress and set quality (0-100)
      final base64Image = base64Encode(compressedBytes);  // Convert to Base64

      // Save to Firestore
      await FirebaseFirestore.instance.collection('classified_images').add({
        'label': label,
        'confidence': confidence,
        'image': base64Image,
        'userId': userId,  // Store the userId
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('Image saved to Firebase!');
    } catch (e) {
      print('Error saving to Firebase: $e');
    }
  }

  /// Shows a modal dialog asking the user if they want to save the image.
  void showSaveModal(BuildContext context, String label, String confidence, File imageFile) {
    final theme = Theme.of(context);  // Access current theme

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save Classified Image'),
        content: const Text('Do you want to save the image to Firebase?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: const Text('Cancel'),


          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
              saveToFirebase(label, confidence, imageFile);
            },
            child: const Text('Save'),

          ),
        ],
      ),
    );
  }
}

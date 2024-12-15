import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModalService {
  /// Saves the image, label, and confidence to Firebase Firestore.
  Future<void> saveToFirebase(String label, String confidence, File imageFile) async {
    try {
      print(label);
      // Convert image to Base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = 'hbhbnnu';

      // Save to Firestore
      await FirebaseFirestore.instance.collection('classified_images').add({
        'label': label,
        'confidence': confidence,
        'image': base64Image,
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('Image saved to Firebase!');
    } catch (e) {
      print('Error saving to Firebase: $e');
    }
  }

  /// Shows a modal dialog asking the user if they want to save the image.
  void showSaveModal(BuildContext context, String label, String confidence, File imageFile) {
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

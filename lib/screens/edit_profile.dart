import 'dart:convert';
import 'dart:io';
import 'package:autophile/core/toast.dart';
import 'package:autophile/models/user_model.dart';
import 'package:autophile/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  UserModel? _user;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fetchStudentProfile();
  }

  Future<void> _fetchStudentProfile() async {
    try {
      String? userId = await _storage.read(key: 'userId');
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user ID found. Please log in again.')),
        );
        return;
      }

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found. Please contact support.')),
        );
        return;
      }

      setState(() {
        _user = UserModel(
          id: doc.id,
          name: doc['name'] ?? 'Unknown User',
          address: doc['address'],
          email: doc['email'] ?? '',
          photo: doc['photo'],
          bio: doc['bio'],
        );

        _nameController.text = _user?.name ?? '';
        _addressController.text = _user?.address ?? '';
        _bioController.text = _user?.bio ?? '';
      });
    } catch (e) {
      debugPrint('Error fetching student profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch profile. Please try again.')),
      );
    }
  }

  Future<void> _uploadProfilePicture() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected.')),
        );
        return;
      }

      setState(() {
        _imageFile = File(pickedFile.path);
      });

      String? userId = await _storage.read(key: 'userId');
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user ID found. Please log in again.')),
        );
        return;
      }

      List<int> imageBytes = await _imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'photo': base64Image,
      });

      await _fetchStudentProfile();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated successfully')),
      );
    } catch (e) {
      debugPrint('Error uploading profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload profile picture.')),
      );
    }
  }

  String getInitials(String username) {
    List<String> nameParts = username.trim().split(' ');
    if (nameParts.isEmpty) return '?';
    String initials = nameParts[0][0].toUpperCase();
    if (nameParts.length > 1) {
      initials += nameParts[nameParts.length - 1][0].toUpperCase();
    }
    return initials;
  }


  void _saveProfile() async {
    try {
      String? userId = await _storage.read(key: 'userId');
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user ID found. Please log in again.')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'bio': _bioController.text.trim(),
      });

      ToastUtils.showSuccess('Profile updated successfully');

      Navigator.pushNamed(context, '/home');

    } catch (e) {
      debugPrint('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save profile. Please try again.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    String initials = getInitials(_user?.name ?? 'Unknown');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _uploadProfilePicture,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.blue,
                                backgroundImage: _user!.photo != null && _user!.photo!.isNotEmpty
                                    ? MemoryImage(base64Decode(_user!.photo!))
                                    : null,
                                child: _user!.photo == null || _user!.photo!.isEmpty
                                    ? Text(
                                  initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2,
                                      )
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _user!.name ?? 'Unknown Name',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _user!.email,
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),

                    // Name
                    AppTextField(
                      controller: _nameController,
                      hintText: 'Enter your name',
                      labelText: 'Name',
                    ),
                    const SizedBox(height: 20),

                    // Address
                    AppTextField(
                      controller: _addressController,
                      hintText: 'Enter your address',
                      labelText: 'Address',
                    ),
                    const SizedBox(height: 20),

                    // Bio
                    AppTextField(
                      controller: _bioController,
                      hintText: 'Tell something about yourself',
                      labelText: 'Bio',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

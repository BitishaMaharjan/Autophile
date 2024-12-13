import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/app_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String _profilePicture = 'assets/images/profile _picture.png';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfilePicture() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _profilePicture = pickedFile.path;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile =
                  await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _profilePicture = pickedFile.path;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveProfile() {
    print('Profile saved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: _profilePicture.startsWith('assets/images/profile _picture.png')
                        ? AssetImage(_profilePicture) as ImageProvider
                        : FileImage(File(_profilePicture)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickProfilePicture,
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
    );
  }
}

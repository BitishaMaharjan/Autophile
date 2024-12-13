import 'dart:convert';
import 'dart:io';
import 'package:autophile/models/post_model.dart';
import 'package:autophile/models/user_model.dart';
import 'package:autophile/widgets/home_screen/home_floating_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autophile/widgets/home_screen/post_list_widget.dart';
import 'package:autophile/widgets/home_screen/carousel_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:autophile/widgets/loading_skeleton.dart';

class HomeScreen extends StatefulWidget {
  final UserModel? user;

  HomeScreen(this.user, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _tagController = TextEditingController();
  List<Map<String, dynamic>> posts = [];

  List<String> tags = [];

  String? selectedImage;
  bool isLoading = true;

  @override
  void dispose() {
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.lightGreenAccent,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  Future<void> fetchPosts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').get();
      List<Map<String, dynamic>> fetchedPosts = snapshot.docs.map((doc) {
        return {
          'caption': doc['caption'] ?? '',
          'createdAt': doc['createdAt'] ?? '',
          'dislikes': doc['dislikes'] ?? 0,
          'image': doc['image'] ?? '',
          'likes': doc['likes'] ?? 0,
          'postId': doc.id,
          'tags': List<String>.from(doc['tags'] ?? []),
          'userId': doc['userId'] ?? 'Unknown',
          'comments': 12,
        };
      }).toList();

      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }


  Future<String> _convertImageToBase64(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _createPost() async {
    if (selectedImage == null || _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please provide an image and caption")));
      return;
    }

    try {
      final imageBase64 = await _convertImageToBase64(selectedImage!);
      final userId = widget.user?.id;

      final post = PostModel(
        postId: null,
        caption: _descriptionController.text.trim(),
        tags: tags,
        image: imageBase64,
        userId: userId!,
        createdAt: DateTime.now(),
      );

      final docRef = await FirebaseFirestore.instance.collection('posts').add(post.toJson());

      await FirebaseFirestore.instance.collection('posts').doc(docRef.id).update({
        'postId': docRef.id,
      });

      if (docRef.id.isNotEmpty) {
        showSuccessToast('Post created successfully');
        Navigator.pop(context);
      } else {
        showErrorToast("Post creation failed. Document ID is empty.");
      }
    } catch (e) {
      print('Error creating post: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error creating post: $e")));
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile.path;
      });
    }
  }

  void _addTag() {
    if (_tagController.text.trim().isNotEmpty) {
      setState(() {
        tags.add(_tagController.text.trim());
      });
      _tagController.clear();
      Navigator.pop(context);
    }
  }

  void _showAddTagDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a Tag"),
        content: TextField(
          controller: _tagController,
          decoration: const InputDecoration(hintText: "Enter tag"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
          ),
          ElevatedButton(
            onPressed: _addTag,
            child: Text("Add",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
          ),
        ],
      ),
    );
  }

  void _showCreatePostPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Post",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Write something...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Tags",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ...tags.map(
                          (tag) => Chip(
                        label: Text(tag),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            tags.remove(tag);
                          });
                        },
                      ),
                    ),
                    ActionChip(
                      label: const Text("Add Tag"),
                      avatar: const Icon(Icons.add),
                      onPressed: _showAddTagDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Image",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: selectedImage != null
                            ? Image.file(
                          File(selectedImage!),
                          fit: BoxFit.cover,
                        )
                            : const Icon(Icons.add_a_photo, size: 40),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: _createPost,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Theme.of(context).colorScheme.secondary
                          ),
                          child: Text("Post",style: TextStyle(color: Theme.of(context).colorScheme.primary),)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,


      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            // Profile Section
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),  // Padding inside the container
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,  // Smaller avatar size
                      backgroundImage: NetworkImage('data:image/jpeg;base64,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'),  // Add image URL here
                    ),
                    SizedBox(width: 4),  // Space between the avatar and text
                    Material(
                      elevation: 3, // Adds shadow for elevation
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                      color: Theme.of(context).colorScheme.primary, // Background color
                      child: Container(
                        padding: EdgeInsets.all(10), // Padding inside the container for the text
                        child: Text(
                          'Hi! ${widget.user?.email ?? 'Guest'}',
                          style: TextStyle(
                            fontSize: 12, // Smaller text size
                            fontWeight: FontWeight.bold, // Bold text
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            SizedBox(height: 4),
            CarouselWidget(),
            SizedBox(height: 20),

            isLoading
                ? LoadingSkeleton(isPost:true,isCarSearch:false)
                :
            PostListWidget(posts: posts),

            // Post Section

          ],
        ),
      ),
        floatingActionButton:HomeFloatingButton(onPressed: _showCreatePostPopup)
    );
  }
}
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autophile/widgets/home_screen/share_option.dart';
import 'package:timeago/timeago.dart' as timeago;


class PostListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> posts;



  PostListWidget({required this.posts});

  @override
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  // Function to show comment modal
  void _showCommentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the modal to take up more space
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              // Display Comments (for testing purposes, showing multiple comments)
              CommentWidget(user: 'User1', content: 'This is a comment', upvotes: 5, downvotes: 2),
              CommentWidget(user: 'User2', content: 'Another interesting comment', upvotes: 3, downvotes: 1),
              CommentWidget(user: 'User3', content: 'Nice post!', upvotes: 7, downvotes: 0),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the comment modal
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {


    return Column(
      children: widget.posts.map((post) {
        int likes = (post['likes'] is int)
            ? post['likes'] as int
            : 0;
        int dislikes = (post['dislikes'] is int)
            ? post['dislikes'] as int
            : 0;
        int comments = (post['comments'] is int)
            ? post['comments'] as int
            : 0;
        String caption = post['caption'] ?? '';
        List<String> tags = [];
        if (post['tags'] is List) {
          tags = List<String>.from(post['tags'] as List);
        } else if (post['tags'] is String) {
          tags = [post['tags'] as String];
        } else {
          tags = [];
        }
        Widget imageWidget;
        try {
          if (post['image'] != null && post['image'].toString().isNotEmpty) {
            Uint8List imageBytes = base64Decode(post['image'].toString());

            imageWidget = Image.memory(
              imageBytes,
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: $error');
                return Image.asset(
                  'assets/placeholder.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                );
              },
            );
          } else {
            imageWidget = Image.asset(
              'assets/placeholder.png',
              width: double.infinity,
              fit: BoxFit.contain,
            );
          }
        } catch (e) {
          print('Error decoding base64 image: $e');
          imageWidget = Image.asset(
            'assets/placeholder.png',
            width: double.infinity,
            fit: BoxFit.contain,
          );
        }


        return Card(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.only(bottom: 15),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Row
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(post['userId'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error loading user data');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(width: 10),
                          Text('Loading...'),
                        ],
                      );
                    }

                    final userData = snapshot.data?.data() as Map<String, dynamic>?;
                    final username = userData?['name'] ?? 'Unknown User';
                    final photoUrl = userData?['photo'] ?? '';

                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: photoUrl == '' ?? true
                            ? NetworkImage('https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png')
                            : NetworkImage(photoUrl),

                          onBackgroundImageError: (_, __) {
                            print('Error loading image');
                          },
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                timeago.format(DateTime.parse(post['createdAt'] ?? DateTime.now().toString())),
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.more_vert, color: Colors.grey),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),

                Text(caption, style: TextStyle(fontSize: 14)),
                SizedBox(height: 10),

                // Tags
                Wrap(
                  spacing: 8,
                  children: tags.map((tag) => Chip(
                    label: Text('#$tag'),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList(),
                ),
                SizedBox(height: 10),

                // Post Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageWidget,
                  ),
                ),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up_outlined),
                          onPressed: () {
                          },
                        ),
                        Text('$likes'),
                      ],
                    ),

                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_down_outlined),
                          onPressed: () {
                          },
                        ),
                        Text('$dislikes'),
                      ],
                    ),

                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.chat_bubble_outline),
                          onPressed: () => _showCommentModal(context),
                        ),
                        Text('$comments'),
                      ],
                    ),


                    // Share Button and Count
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.share_outlined, size: 24),
                          color: Colors.grey,
                          onPressed: () {
                           // Replace with dynamic link
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => ShareOptions(
                              postLink:  "https://autophile.com/path-to-user-image.jpg",
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                              ),
                            );
                          },

                        ),
                        Text('$shares'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CommentWidget extends StatefulWidget {
  final String user;
  final String content;
  final int upvotes;
  final int downvotes;

  CommentWidget({
    required this.user,
    required this.content,
    required this.upvotes,
    required this.downvotes,
  });

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late int upvotes;
  late int downvotes;

  @override
  void initState() {
    super.initState();
    upvotes = widget.upvotes;
    downvotes = widget.downvotes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://via.placeholder.com/60'),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(widget.content, style: TextStyle(fontSize: 14)),
              ],
            ),
            Spacer(),
            // Upvote/Downvote for the comment
            Row(
              children: [

                IconButton(
                  icon: Image.asset('assets/icons/upvote.png', width: 20, height: 20),
                  onPressed: () {
                    setState(() {
                      upvotes++;
                    });
                  },
                ),
                Text('$upvotes'),
                IconButton(
                  icon: Image.asset('assets/icons/downvote.png', width: 20, height: 20),
                  onPressed: () {
                    setState(() {
                      downvotes++;
                    });
                  },
                ),
                Text('$downvotes'),
              ],
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autophile/widgets/home_screen/share_option.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:autophile/models/comment_model.dart';


class PostListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> posts;



  PostListWidget({required this.posts});

  @override
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  // void _showCommentModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.7,
  //         child: Padding(
  //           padding: EdgeInsets.only(
  //             bottom: MediaQuery.of(context).viewInsets.bottom,
  //             left: 16,
  //             right: 16,
  //             top: 16,
  //           ),
  //           child: CommentWidget(
  //             username: 'User1',
  //             commentText: 'This is a comment',
  //             time: '5m ago',
  //             onRespond: () {
  //               print('Respond tapped');
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
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
                    final userId = userData?['userId'];
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
                          onPressed: (){
                        showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) {
                        return FractionallySizedBox(
                        heightFactor: 0.7, // Adjust the height as needed
                        child: CommentWidget(postId: post['postId'], userId : post['userId'] ),
                        );
                        },
                        );
                        }
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


// Widget to display and add comments for a specific post.
class CommentWidget extends StatefulWidget {
  final String postId;
  final String userId;

  const CommentWidget({required this.postId, required this.userId, Key? key}) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSending = false;
  List<CommentModel> _comments = [];

  Future<void> _addComment(String text) async {
    setState(() {
      _isSending = true;
    });

    try {
      final userId = widget.userId;
      final commentId = FirebaseFirestore.instance.collection('comments').doc().id;

      final comment = CommentModel(
        commentId: commentId,
        postId: widget.postId,
        userId: userId,
        text: text,
        createdAt: DateTime.now(),
      );

      // Temporarily add the comment to the list before saving it
      setState(() {
        _comments.insert(0, comment);
      });

      await FirebaseFirestore.instance
          .collection('comments')
          .doc(commentId)
          .set(comment.toJson());

      _commentController.clear();
    } catch (e) {
      print("Error adding comment: $e");
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(

            stream: FirebaseFirestore.instance
                .collection('comments')
                .where('postId', isEqualTo: widget.postId)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data!.docs.map((e) => e.data()).toList());
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No comments yet"));
              }

              final comments = snapshot.data!.docs.map((doc) {
                return CommentModel.fromSnapshot(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                );
              }).toList();

              return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    title: Text(comment.text),
                    subtitle: Text("By ${comment.userId} - ${comment.createdAt.toLocal().toString()}"),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Add a comment...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),
                ),
              ),
              IconButton(
                icon: _isSending
                    ? CircularProgressIndicator()
                    : Icon(Icons.send),
                onPressed: _isSending
                    ? null
                    : () {
                  if (_commentController.text.trim().isNotEmpty) {
                    _addComment(_commentController.text.trim());
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
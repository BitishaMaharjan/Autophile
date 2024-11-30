import 'package:flutter/material.dart';

class PostListWidget extends StatefulWidget {
  final List<Map<String, String>> posts;

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
        int upvotes = int.tryParse(post['upvotes'] ?? '0') ?? 0;
        int downvotes = int.tryParse(post['downvotes'] ?? '0') ?? 0;
        int likes = int.tryParse(post['likes'] ?? '0') ?? 0;
        int comments = int.tryParse(post['comments'] ?? '0') ?? 0;
        int shares = int.tryParse(post['shares'] ?? '0') ?? 0;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.only(bottom: 15),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('data:image/jpeg;base64,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'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['user'] ?? 'Unknown User', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(post['location'] ?? 'Unknown Location', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.bookmark_outline, color: Colors.grey),
                  ],
                ),
                SizedBox(height: 10),

                // Post Content
                Text(post['content'] ?? '', style: TextStyle(fontSize: 14)),
                SizedBox(height: 10),

                // Post Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(post['image'] ?? 'https://via.placeholder.com/400', width: double.infinity, fit: BoxFit.contain),
                  ),
                ),
                SizedBox(height: 10),

                // Action Row with Equal Distribution in a Single Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute all actions equally
                  children: [
                    // Upvote Button and Count
                    Row(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/icons/upvote.png', width: 24, height: 24),
                          onPressed: () {
                            setState(() {
                              upvotes++;
                            });
                          },
                        ),
                        Text('$upvotes'),
                      ],
                    ),

                    // Downvote Button and Count
                    Row(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/icons/downvote.png', width: 24, height: 24),
                          onPressed: () {
                            setState(() {
                              downvotes++;
                            });
                          },
                        ),
                        Text('$downvotes'),
                      ],
                    ),

                    // Comment Button and Count
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.chat, size: 24),
                          color: Colors.grey,
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
                            // Handle share action
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

import 'package:flutter/material.dart';

class PostListWidget extends StatefulWidget {
  final List<Map<String, String>> posts;

  PostListWidget({required this.posts});

  @override
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  void _showCommentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: CommentWidget(
              username: 'User1',
              commentText: 'This is a comment',
              time: '5m ago',
              onRespond: () {
                print('Respond tapped');
              },
            ),
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
                      backgroundImage: NetworkImage('https://via.placeholder.com/40'),
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

                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(post['image'] ?? 'https://via.placeholder.com/400', width: double.infinity, fit: BoxFit.contain),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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

                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.share_outlined, size: 24),
                          color: Colors.grey,
                          onPressed: () {
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
  final String username;
  final String commentText;
  final String time;
  final VoidCallback onRespond;

  const CommentWidget({
    required this.username,
    required this.commentText,
    required this.time,
    required this.onRespond,
    Key? key,
  }) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              Text(
                'Comments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Info Icon
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                },
              ),
            ],
          ),
        ),

        Divider(height: 1, color: Colors.grey),

        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/profile_picture.png'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.time,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.commentText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: widget.onRespond,
                              child: Text(
                                "Respond",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.emoji_emotions_outlined, size: 28),
                Icon(Icons.sentiment_satisfied_alt, size: 28),
                Icon(Icons.sentiment_dissatisfied, size: 28),
                Icon(Icons.sentiment_very_dissatisfied, size: 28),
                Icon(Icons.sentiment_neutral, size: 28),
                Icon(Icons.sentiment_very_satisfied, size: 28),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/profile_picture.png'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Add a comment...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                  },
                  icon: Icon(Icons.send, color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ],
    );
  }
}



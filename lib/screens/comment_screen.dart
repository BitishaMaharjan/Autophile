import 'package:flutter/material.dart';

import '../widgets/comment_widget.dart';

class CommentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample comment data
    final comments = [
      {
        'username': 'helloworld',
        'commentText': 'must be around \$12000',
        'time': '1 hour ago',
      },
      {
        'username': 'cargod',
        'commentText': '\$30000',
        'time': '1 hour ago',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Handle info action
            },
            icon: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Comments List
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return CommentWidget(
                    username: comment['username']!,
                    commentText: comment['commentText']!,
                    time: comment['time']!,
                    onRespond: () {
                    },
                  );
                },
              ),
            ),
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
            // Add a new comment section
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/landing_background.jpg'),
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
                    // Handle adding a comment
                  },
                  icon: Icon(Icons.send, color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

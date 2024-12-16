import 'dart:convert';
import 'dart:typed_data';
import 'package:autophile/core/toast.dart';
import 'package:autophile/models/notification_model.dart';
import 'package:autophile/models/user_reaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autophile/widgets/home_screen/share_option.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:autophile/models/comment_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class PostListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> posts;



  PostListWidget({required this.posts});

  @override
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {

  final Map<String, Map<String, int>> localVoteCounts = {};
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final Map<String, Stream<int>> commentCountStreams = {};

  @override
  void initState() {
    super.initState();
    for (var post in widget.posts) {
      localVoteCounts[post['postId']] = {
        'upvote': post['upvote'] ?? 0,
        'downvote': post['downvote'] ?? 0,
      };
      commentCountStreams[post['postId']] = getCommentCountStream(post['postId']);
    }
  }

  Stream<int> getCommentCountStream(String postId) {
    return FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<bool> checkIfFavorited(String postId) async {
    try {
      final userId = await storage.read(key: 'userId');
      final favoritesRef = await FirebaseFirestore.instance
          .collection('favourites')
          .where('userId', isEqualTo: userId)
          .where('postId', isEqualTo: postId)
          .get();

      return favoritesRef.docs.isNotEmpty;
    } catch (e) {
      print("Error checking if post is favorited: $e");
      return false;
    }
  }

  Future<bool> addToFavourite(String postId) async {
    try {
      final storage = FlutterSecureStorage();
      final userId = await storage.read(key: 'userId');
      if (userId != null) {
        final favoritesRef = await FirebaseFirestore.instance
            .collection('favourites')
            .where('userId', isEqualTo: userId)
            .where('postId', isEqualTo: postId)
            .get();

        if (favoritesRef.docs.isNotEmpty) {
          await favoritesRef.docs.first.reference.delete();
          ToastUtils.showSuccess('Removed from favorites');
        } else {
          final favouriteDocRef = await FirebaseFirestore.instance
              .collection('favourites')
              .add({
            'postId': postId,
            'userId': userId,
            'createdAt': FieldValue.serverTimestamp(),
          });

          ToastUtils.showSuccess('Added to favorites');

          final notificationRef = FirebaseFirestore.instance.collection('notifications');
          final existingNotification = await notificationRef
              .where('userId', isEqualTo: userId)
              .where('postId', isEqualTo: postId)
              .where('type', isEqualTo: 'fav')
              .limit(1)
              .get();

          if (existingNotification.docs.isEmpty) {
            final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
            final postSnapshot = await postRef.get();
            final postOwnerId = postSnapshot.data()?['userId'];

            if (postOwnerId != userId) {
              final notification = NotificationModel(
                userId: userId,
                postOwnerId: postOwnerId!,
                postId: postId,
                type: 'fav',
                createdAt: Timestamp.now(),
                isRead: false,
              );

              await notificationRef.add(notification.toJson());
            }
          }
          return true;
        }
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to add favorites')),
        );
        return false;
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
      return false;
    }
  }


  Future handleUpvote(String postId) async {
    try {
      final storage = FlutterSecureStorage();
      final userId = await storage.read(key: 'userId');
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to vote')),
        );
        return;
      }

      final userReactionsRef = FirebaseFirestore.instance.collection('userReactions');
      final postsRef = FirebaseFirestore.instance.collection('posts').doc(postId);

      final querySnapshot = await userReactionsRef
          .where('postId', isEqualTo: postId)
          .where('userId', isEqualTo: userId)
          .get();

      setState(() {
        if (querySnapshot.docs.isNotEmpty) {
          final userReaction = UserReaction.fromFirestore(
              querySnapshot.docs.first.id, querySnapshot.docs.first.data());

          if (userReaction.upvote) {
            localVoteCounts[postId]!['upvote'] = (localVoteCounts[postId]!['upvote'] ?? 0) - 1;
          } else if (userReaction.downvote) {
            localVoteCounts[postId]!['upvote'] = (localVoteCounts[postId]!['upvote'] ?? 0) + 1;
            localVoteCounts[postId]!['downvote'] = (localVoteCounts[postId]!['downvote'] ?? 0) - 1;
          } else {
            localVoteCounts[postId]!['upvote'] = (localVoteCounts[postId]!['upvote'] ?? 0) + 1;
          }
        } else {
          localVoteCounts[postId]!['upvote'] = (localVoteCounts[postId]!['upvote'] ?? 0) + 1;
        }
      });

      if (querySnapshot.docs.isNotEmpty) {
        final reactionDoc = querySnapshot.docs.first;
        final userReaction = UserReaction.fromFirestore(reactionDoc.id, reactionDoc.data());

        if (userReaction.upvote) {
          await postsRef.update({'upvote': FieldValue.increment(-1)});
          await reactionDoc.reference.update({'upvote': false});
        } else if (userReaction.downvote) {
          await postsRef.update({
            'upvote': FieldValue.increment(1),
            'downvote': FieldValue.increment(-1),
          });
          await reactionDoc.reference.update({'upvote': true, 'downvote': false});
        } else {
          await postsRef.update({'upvote': FieldValue.increment(1)});
          await reactionDoc.reference.update({'upvote': true});
        }
      } else {
        await postsRef.update({'upvote': FieldValue.increment(1)});
        await userReactionsRef.add(UserReaction(
          postId: postId,
          userId: userId,
          upvote: true,
        ).toJson());
      }

      final notificationRef = FirebaseFirestore.instance.collection('notifications');
      final existingNotification = await notificationRef
          .where('userId', isEqualTo: userId)
          .where('postId', isEqualTo: postId)
          .where('type', isEqualTo: 'upvote')
          .limit(1)
          .get();

      if (existingNotification.docs.isEmpty) {
        final postSnapshot = await postsRef.get();
        final postOwnerId = postSnapshot.data()?['userId'];

        if (postOwnerId != userId) {
          final notification = NotificationModel(
            userId: userId,
            postOwnerId: postOwnerId!,
            postId: postId,
            type: 'upvote',
            createdAt: Timestamp.now(),
            isRead: false,
          );

          await notificationRef.add(notification.toJson());
        }
      }

    } catch (e) {
      print('Error handling upvote: $e');
      setState(() {
        localVoteCounts[postId] = {
          'upvote': widget.posts.firstWhere((p) => p['postId'] == postId)['upvote'] ?? 0,
          'downvote': widget.posts.firstWhere((p) => p['postId'] == postId)['downvote'] ?? 0,
        };
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update vote')),
      );
    }
  }


  Future<void> handleDownvote(String postId) async {
    try {
      final storage = FlutterSecureStorage();
      final userId = await storage.read(key: 'userId');
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to vote')),
        );
        return;
      }

      final userReactionsRef = FirebaseFirestore.instance.collection('userReactions');
      final postsRef = FirebaseFirestore.instance.collection('posts').doc(postId);

      final querySnapshot = await userReactionsRef
          .where('postId', isEqualTo: postId)
          .where('userId', isEqualTo: userId)
          .get();

      setState(() {
        if (querySnapshot.docs.isNotEmpty) {
          final userReaction = UserReaction.fromFirestore(
              querySnapshot.docs.first.id, querySnapshot.docs.first.data());

          if (userReaction.downvote) {
            localVoteCounts[postId]!['downvote'] = (localVoteCounts[postId]!['downvote'] ?? 0) - 1;
          } else if (userReaction.upvote) {
            localVoteCounts[postId]!['downvote'] = (localVoteCounts[postId]!['downvote'] ?? 0) + 1;
            localVoteCounts[postId]!['upvote'] = (localVoteCounts[postId]!['upvote'] ?? 0) - 1;
          } else {
            localVoteCounts[postId]!['downvote'] = (localVoteCounts[postId]!['downvote'] ?? 0) + 1;
          }
        } else {
          localVoteCounts[postId]!['downvote'] = (localVoteCounts[postId]!['downvote'] ?? 0) + 1;
        }
      });

      if (querySnapshot.docs.isNotEmpty) {
        final reactionDoc = querySnapshot.docs.first;
        final userReaction = UserReaction.fromFirestore(reactionDoc.id, reactionDoc.data());

        if (userReaction.downvote) {
          await postsRef.update({'downvote': FieldValue.increment(-1)});
          await reactionDoc.reference.update({'downvote': false});
        } else if (userReaction.upvote) {
          await postsRef.update({
            'downvote': FieldValue.increment(1),
            'upvote': FieldValue.increment(-1),
          });
          await reactionDoc.reference.update({'downvote': true, 'upvote': false});
        } else {
          await postsRef.update({'downvote': FieldValue.increment(1)});
          await reactionDoc.reference.update({'downvote': true});
        }
      } else {
        await postsRef.update({'downvote': FieldValue.increment(1)});
        await userReactionsRef.add(UserReaction(
          postId: postId,
          userId: userId,
          downvote: true,
        ).toJson());
      }

      final notificationRef = FirebaseFirestore.instance.collection('notifications');
      final existingNotification = await notificationRef
          .where('userId', isEqualTo: userId)
          .where('postId', isEqualTo: postId)
          .where('type', isEqualTo: 'downvote')
          .limit(1)
          .get();

      if (existingNotification.docs.isEmpty) {
        final postSnapshot = await postsRef.get();
        final postOwnerId = postSnapshot.data()?['userId'];

        if (postOwnerId != userId) {
          final notification = NotificationModel(
            userId: userId,
            postOwnerId: postOwnerId!,
            postId: postId,
            type: 'downvote',
            createdAt: Timestamp.now(),
            isRead: false,
          );

          await notificationRef.add(notification.toJson());
        }
      }
    } catch (e) {
      print('Error handling downvote: $e');
      setState(() {
        localVoteCounts[postId] = {
          'upvote': widget.posts.firstWhere((p) => p['postId'] == postId)['upvote'] ?? 0,
          'downvote': widget.posts.firstWhere((p) => p['postId'] == postId)['downvote'] ?? 0,
        };
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update vote')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {


    return Column(
      children: widget.posts.map((post) {
        int upvote = localVoteCounts[post['postId']]?['upvote'] ?? 0;
        int downvote = localVoteCounts[post['postId']]?['downvote'] ?? 0;
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
                              : MemoryImage(base64Decode(photoUrl)),

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
                        FutureBuilder<bool>(
                          future: checkIfFavorited(post['postId']),
                          builder: (context, initialSnapshot) {
                            bool isFavorited = initialSnapshot.data ?? false;

                            return StatefulBuilder(
                              builder: (context, setLocalState) {
                                return IconButton(
                                  icon: Icon(
                                    isFavorited ? Icons.bookmark : Icons.bookmark_border,
                                    color: isFavorited ? Colors.orange : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    setLocalState(() {
                                      isFavorited = !isFavorited;
                                    });

                                    try {
                                      await addToFavourite(post['postId']);
                                    } catch (e) {
                                      setLocalState(() {
                                        isFavorited = !isFavorited;
                                      });
                                      print('Error toggling favorite: $e');
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                        FutureBuilder<String?>(
                          future: storage.read(key: 'userId'),
                          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox.shrink();
                            }

                            if (snapshot.hasError || !snapshot.hasData) {
                              return SizedBox.shrink();
                            }

                            if (snapshot.data == post['userId']) {
                              return PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert),
                                onSelected: (value) async {
                                  if (value == 'delete') {
                                    bool confirm = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete Post'),
                                          content: Text('Are you sure you want to delete this post?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.inversePrimary,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.inversePrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirm) {
                                      try {
                                        final firestore = FirebaseFirestore.instance;

                                        final querySnapshot = await firestore
                                            .collection('posts')
                                            .where('postId', isEqualTo: post['postId'])
                                            .where('userId', isEqualTo: post['userId'])
                                            .get();

                                        for (var doc in querySnapshot.docs) {
                                          await doc.reference.delete();
                                        }

                                        print('Post deleted successfully');
                                      } catch (e) {
                                        print('Error deleting post: $e');
                                      }
                                    }

                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete Post'),
                                  ),
                                ],
                              );
                            }

                            return SizedBox.shrink();
                          },
                        )

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
                          icon: Image.asset('assets/icons/upvote.png'),
                          onPressed: ()=>handleUpvote(post['postId']),
                        ),
                        Text('$upvote'),
                      ],
                    ),

                    Row(
                      children: [
                        IconButton(

                          icon: Image.asset('assets/icons/downvote.png'),
                          onPressed: ()=>handleDownvote(post['postId']),
                        ),
                        Text('$downvote'),
                      ],
                    ),

                    Row(
                      children: [
                        IconButton(
                        icon: Icon(Icons.chat_bubble_outline),
                            color: Colors.grey,
                        onPressed: () {
                        showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) {
                        return FractionallySizedBox(
                        heightFactor: 0.7,
                        child: CommentWidget(postId: post['postId']),
                        );
                        },
                        );
                        }
                        ),
                        StreamBuilder<int>(
                        stream: commentCountStreams[post['postId']],
                        builder: (context, snapshot) {
                        if (snapshot.hasError) {
                        return Text('0');
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                        strokeWidth: 2,
                        ),
                        );
                        }
                        return Text('${snapshot.data ?? 0}');
                        },
                        ),
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

class CommentWidget extends StatefulWidget {
  final String postId;

  const CommentWidget({required this.postId, Key? key}) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSending = false;
  final storage = FlutterSecureStorage();

  Future<void> _addComment(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    try {
      final userId = await storage.read(key: 'userId');
      final commentId = FirebaseFirestore.instance.collection('comments').doc().id;

      final comment = CommentModel(
        commentId: commentId,
        postId: widget.postId,
        userId: userId!,
        text: text,
        createdAt: DateTime.now(),
      );

      // Add the comment to the comments collection
      await FirebaseFirestore.instance
          .collection('comments')
          .doc(commentId)
          .set(comment.toJson());

      // Create a notification for the comment
      final postRef = FirebaseFirestore.instance.collection('posts').doc(widget.postId);
      final postSnapshot = await postRef.get();
      final postOwnerId = postSnapshot.data()?['userId']; // Post owner ID from post document

      if (postOwnerId != userId) {
        final notification = NotificationModel(
          userId: userId,
          postOwnerId: postOwnerId!,
          postId: widget.postId,
          type: 'comment', // Notification type for 'comment'
          createdAt: Timestamp.now(),
          isRead: false,
        );

        await FirebaseFirestore.instance.collection('notifications').add(notification.toJson());
      }

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
        // Header
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
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey),

        // Comments List
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('comments')
                .where('postId', isEqualTo: widget.postId)
                .snapshots(),
            builder: (context, snapshot) {
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(comment.userId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircleAvatar(
                                radius: 20,
                                child: CircularProgressIndicator(),
                              );
                            }

                            final userData = snapshot.data?.data() as Map<String, dynamic>?;
                            final photoUrl = userData?['photo'] ?? '';

                            return CircleAvatar(
                              radius: 20,
                              backgroundImage: photoUrl.isNotEmpty
                                  ? MemoryImage(base64Decode(photoUrl))
                                  : NetworkImage('https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png'),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(comment.userId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircleAvatar(
                                radius: 20,
                                child: CircularProgressIndicator(),
                              );
                            }

                            final userData = snapshot.data?.data() as Map<String, dynamic>?;
                            final username = userData?['name'] ?? 'Unknown User';

                            return
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child:
                                        Text(
                                          username,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        )),
                                        const SizedBox(width: 8),
                                        Text(
                                          timeago.format(comment.createdAt),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context).colorScheme.onPrimary,
                                          ),
                                        ),

                                        FutureBuilder<String?>(
                                          future: storage.read(key: 'userId'),
                                          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return SizedBox.shrink();
                                            }

                                            if (snapshot.hasError || !snapshot.hasData) {
                                              return SizedBox.shrink();
                                            }

                                            if (snapshot.data == userData?['userId']) {
                                              return PopupMenuButton<String>(
                                                icon: Icon(Icons.more_vert,size: 15,),
                                                onSelected: (value) async {
                                                  if (value == 'delete') {
                                                    bool confirm = await showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Delete Comment'),
                                                          content: Text('Are you sure you want to delete this comment?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                  color: Theme.of(context).colorScheme.inversePrimary,
                                                                ),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop(true);
                                                              },
                                                              child: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                  color: Theme.of(context).colorScheme.inversePrimary,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );

                                                    if (confirm) {
                                                      try {
                                                        final firestore = FirebaseFirestore.instance;

                                                        final querySnapshot = await firestore
                                                            .collection('comments')
                                                            .where('postId', isEqualTo: widget.postId)
                                                            .where('userId', isEqualTo: userData?['userId'])
                                                            .get();

                                                        for (var doc in querySnapshot.docs) {
                                                          await doc.reference.delete();
                                                        }

                                                        print('Post deleted successfully');
                                                      } catch (e) {
                                                        print('Error deleting post: $e');
                                                      }
                                                    }

                                                  }
                                                },
                                                itemBuilder: (BuildContext context) => [
                                                  const PopupMenuItem<String>(
                                                    value: 'delete',
                                                    child: Text('Delete Comment'),
                                                  ),
                                                ],
                                              );
                                            }

                                            return SizedBox.shrink();
                                          },
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      comment.text,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Comment Input
        Column(
          children: [
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
                    controller: _commentController,
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
                  onPressed: _isSending
                      ? null
                      : () => _addComment(_commentController.text.trim()),
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














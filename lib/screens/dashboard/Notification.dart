import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  List<Map<String, dynamic>> notifications = [];


  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  String _getTitle(String type) {
    switch (type) {
      case 'upvote':
        return 'Upvote on Your Post';
      case 'fav':
        return 'Added to Your Favorites';
      case 'comment':
        return 'New Comment on Your Post';
      case 'downvote':
        return 'Downvote on Your Post';
      default:
        return 'New Notification';
    }
  }

  String _getDescription(String type, String userName, String postId) {
    switch (type) {
      case 'upvote':
        return '$userName upvoted your post';
      case 'downvote':
        return '$userName downvoted your post';
      case 'fav':
        return '$userName added your post to favorites';
      case 'comment':
        return '$userName commented on your post';
      default:
        return 'You have a new notification';
    }
  }

  String _formatTime(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
  }

  void _toggleReadStatus(int index) {
    setState(() {
      notifications[index]["isRead"] = !notifications[index]["isRead"];
    });
  }

  Future<void> _fetchNotifications() async {
    try {
      final userId = await _storage.read(key: 'userId');

      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('postOwnerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      for (var doc in snapshot.docs) {
        final notification = doc.data();

        final userId = notification['userId'] as String?;
        final type = notification['type'] as String?;
        final createdAt = notification['createdAt'] as Timestamp?;
        final postId = notification['postId'] as String?;
        final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
        final userSnapshot = await userRef.get();
        final userName = userSnapshot.data()?['name'] ?? 'Unknown User';

        notifications.add({
          'id': doc.id,
          'title': _getTitle(type!),
          'description': _getDescription(type, userName, postId ?? ''),
          'time': _formatTime(createdAt!),
          'isRead': notification['isRead'] ?? false,
          'type': type,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.mark_email_read),
            onPressed: () {
              setState(() {
                for (var notification in notifications) {
                  notification["isRead"] = true;
                }
              });
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(child: Text('No notifications'))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          Color notificationColor =
          notification["isRead"] ? Theme.of(context).colorScheme.primary.withOpacity(0.7) : Colors.blue.shade50.withOpacity(0.4);
          Icon notificationIcon;
          switch (notification["type"]) {
            case "comment":
              notificationIcon = Icon(Icons.comment, color: Colors.orange);
              break;
            case "upvote":
              notificationIcon = Icon(Icons.thumb_up, color: Colors.green);
              break;
            case "downvote":
              notificationIcon = Icon(Icons.thumb_down, color: Colors.red);
              break;
            case "fav":
              notificationIcon = Icon(Icons.favorite, color: Colors.red);
              break;
            default:
              notificationIcon = Icon(Icons.notifications, color: Colors.grey);
          }

          return Dismissible(
            key: Key(notification["title"] ?? ""),
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${notification['title']} is removed!"),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      setState(() {
                        notifications.insert(index, notification);
                      });
                    },
                    textColor: Colors.white,
                  ),
                  backgroundColor: Colors.black,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: notificationColor,
                child: ListTile(
                  contentPadding: EdgeInsets.all(14),
                  title: Row(
                    children: [
                      notificationIcon,
                      SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notification["title"] ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: notification["isRead"]
                                          ? Theme.of(context).colorScheme.inversePrimary
                                          : Theme.of(context).colorScheme.secondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  notification["time"] ?? "",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              notification["description"] ?? "",
                              style: TextStyle(fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _toggleReadStatus(index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
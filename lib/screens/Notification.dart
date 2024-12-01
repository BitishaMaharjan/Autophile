import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Map<String, dynamic>> notifications = [
    {
      "title": "New Message",
      "description": "You have a new message from John",
      "time": "9:08 a.m.",
      "isRead": false,
      "type": "message",
    },
    {
      "title": "Upvote on Your Post",
      "description": "Your post received an upvote from Alice",
      "time": "10:15 a.m.",
      "isRead": true,
      "type": "upvote",
    },
    {
      "title": "Downvote on Your Comment",
      "description": "Your comment received a downvote",
      "time": "11:00 a.m.",
      "isRead": false,
      "type": "downvote",
    },
    {
      "title": "New Commit",
      "description":
      "Commit 12345 added new features to the repository. Check out the details!",
      "time": "10:30 a.m.",
      "isRead": false,
      "type": "commit",
    },
  ];

  void _toggleReadStatus(int index) {
    setState(() {
      notifications[index]["isRead"] = !notifications[index]["isRead"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
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
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          Color notificationColor =
          notification["isRead"] ? Colors.white : Colors.blue[50]!;
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
            case "commit":
              notificationIcon = Icon(Icons.code, color: Colors.green);
              break;
            default:
              notificationIcon = Icon(Icons.notifications, color: Colors.grey);
          }


        },
      ),
    );
  }
}

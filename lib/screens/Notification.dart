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

          return Dismissible(
            key: Key(notification["title"] ?? ""),
            onDismissed: (direction) {
              // Save the notification that is being removed
              final removedNotification = notifications[index];

              // Remove the notification from the list
              setState(() {
                notifications.removeAt(index);
              });

              // Show the SnackBar with an undo action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(" ${removedNotification['title']} is removed!"),
                  behavior: SnackBarBehavior.floating, // Make the snack bar float
                  margin: EdgeInsets.fromLTRB(20, 50, 20, 20), // Ensure the snack bar doesn't go out of bounds
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      // Restore the notification back to the list
                      setState(() {
                        notifications.insert(index, removedNotification);
                      });
                    },
                    textColor: Colors.white, // Set the undo button text color to white
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
                                          ? Colors.black
                                          : Colors.blue,
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
                              style: TextStyle(fontSize: 14, color: Colors.black),
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

import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  final String username;
  final String commentText;
  final String time;
  final VoidCallback onRespond;

  CommentWidget({
    required this.username,
    required this.commentText,
    required this.time,
    required this.onRespond,
  });

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/landing_background.jpg'),

              ),
              const SizedBox(width: 16,),
              Expanded(child: Column(
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
                      const SizedBox(width: 8,),
                      Text(
                        widget.time,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color:Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Text(
                        widget.commentText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8,),
                      GestureDetector(
                        onTap: widget.onRespond,
                        child: Text("Respond",
                        style: TextStyle(
                          fontSize: 14,
                          color:Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w400,
                        ),),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.emoji_emotions_outlined, size: 28, color:Theme.of(context).colorScheme.onPrimary),
                          Icon(Icons.sentiment_satisfied_alt, size: 28,  color:Theme.of(context).colorScheme.onPrimary),
                          Icon(Icons.sentiment_dissatisfied, size: 28,  color:Theme.of(context).colorScheme.onPrimary),
                          Icon(Icons.sentiment_very_dissatisfied, size: 28,  color:Theme.of(context).colorScheme.onPrimary),
                          Icon(Icons.sentiment_neutral, size: 28, color:Theme.of(context).colorScheme.onPrimary),
                          Icon(Icons.sentiment_very_satisfied, size: 28,  color:Theme.of(context).colorScheme.onPrimary),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/images/landing_background.jpg'),

                          ),
                          const SizedBox(width: 8,),
                          Expanded(child: TextField(
                            decoration: InputDecoration(
                              hintText: "Add a comment...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          )),
                          const SizedBox(width: 20,),
                          IconButton(onPressed: (){}, icon: Icon(Icons.send,color: Theme.of(context).colorScheme.onPrimary,))
                        ],
                      )
                    ],
                  )

                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}

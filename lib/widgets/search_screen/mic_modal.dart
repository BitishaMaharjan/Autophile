import 'package:flutter/material.dart';

class MicModal extends StatelessWidget {
  const MicModal();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mic, size: 50, color: Colors.blue),
          SizedBox(height: 10),
          Text("Listening...", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as st;
import 'package:autophile/screens/dashboard/search_result.dart';
import 'package:autophile/screens/dashboard/search_page.dart';

class MicSearchModal extends StatefulWidget {
  @override
  _MicSearchModalState createState() => _MicSearchModalState();
}

class _MicSearchModalState extends State<MicSearchModal> with SingleTickerProviderStateMixin {
  bool isListening = false;
  String speechText = '';
  final st.SpeechToText _speechToText = st.SpeechToText();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _speechToText.initialize();

    // Set up the animation for the sound wave effect
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void toggleListening() async {
    if (isListening) {
      // Stop listening and animation
      await _speechToText.stop();
      setState(() => isListening = false);
      _controller.stop();
      performSearch();
    } else {
      // Start listening and animation
      bool available = await _speechToText.listen(onResult: (result) {
        setState(() {
          speechText = result.recognizedWords;
        });
      });

      if (available) {
        setState(() => isListening = true);
        _controller.repeat(reverse: true);
      }
    }
  }

  void performSearch() {
    if (speechText.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsWidget(initialSearchQuery: speechText),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: toggleListening,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: 100 * _animation.value,
                    height: 100 * _animation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isListening ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.mic,
                      size: 50,
                      color: isListening ? Colors.blue : Colors.grey,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              isListening ? "Listening..." : "Tap to speak",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              speechText.isEmpty ? "Say something..." : " $speechText",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            if (speechText.isNotEmpty && !isListening) ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: performSearch,
                child: Text("Search"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue[400]), // Set the button color here
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareOptions extends StatelessWidget {
  final String postLink;

  const ShareOptions({Key? key, required this.postLink}) : super(key: key);

  // Launch URL function
  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _shareToFacebook(String postLink) {
    final facebookUrl = "https://www.facebook.com/sharer/sharer.php?u=$postLink";
    _launchUrl(facebookUrl);
  }

  void _shareToInstagram(String postLink) {
    final instagramUrl = "https://www.instagram.com/?url=$postLink";
    _launchUrl(instagramUrl);
  }

  void _shareToWhatsApp(String postLink) {
    final whatsappUrl = "https://wa.me/?text=$postLink";
    _launchUrl(whatsappUrl);
  }

  void _copyLink(BuildContext context, String postLink) {
    Clipboard.setData(ClipboardData(text: postLink));
    Navigator.pop(context); // Close the modal

    // Show a centered message
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 48, color: Colors.green),
              const SizedBox(height: 12),
              Text(
                'Link Copied!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(postLink, style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        );
      },
    );

    // Automatically close the dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Share Post",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShareButton(
                context,
                icon: Icons.facebook,
                label: 'Facebook',
                onPressed: () => _shareToFacebook(postLink),
              ),
              _buildShareButton(
                context,
                icon: Icons.camera_alt,
                label: 'Instagram',
                onPressed: () => _shareToInstagram(postLink),
              ),
              _buildShareButton(
                context,
                icon: Icons.chat,
                label: 'WhatsApp',
                onPressed: () => _shareToWhatsApp(postLink),
              ),
              _buildShareButton(
                context,
                icon: Icons.link,
                label: 'Copy Link',
                onPressed: () => _copyLink(context, postLink),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onPressed,
      }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 32),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
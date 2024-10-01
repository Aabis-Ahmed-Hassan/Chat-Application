import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsScreen extends StatelessWidget {
  // Function to launch URL with Uri
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // Convert string to Uri
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credits'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LinkText(
              'App Icon made by Creartive from www.flaticon.com\n',
              'https://flaticon.com/',
            ),
            Text(
              'App developed by Aabis Ahmed Hassan\n',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'My Socials:\n',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            LinkText('GitHub: github.com/aabis-ahmed-hassan',
                'https://github.com/aabis-ahmed-hassan'),
            SizedBox(height: 8),
            LinkText('LinkedIn: linkedin.com/in/aabis-ahmed-hassan',
                'https://linkedin.com/in/aabis-ahmed-hassan'),
            SizedBox(height: 8),
            LinkText('Instagram: instagram.com/aabis-ahmed-hassan',
                'https://instagram.com/aabis-ahmed-hassan'),
          ],
        ),
      ),
    );
  }

  Widget LinkText(String title, String link) {
    return GestureDetector(
      onTap: () => _launchURL(link),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

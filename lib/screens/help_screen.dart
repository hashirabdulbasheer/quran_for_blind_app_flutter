import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  static const String _youtubeUrl = "https://www.youtube.com/watch?v=KZoIFMhi8hk";
  static const String _message = """Assalamu Alaikum, This Quran app was designed, with lots of love, for the visually challenged. The app has been optimized to function with screen readers such as talkback on Android and voice-over on iPhone. Use these screen readers to read the Arabic and English versions of the Quran. High contrast colors have also been used. More features coming soon...""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ColorScheme.dark().background,
      appBar: AppBar(
        title: Text(
          "Help",
          style: Theme.of(context).textTheme.titleLarge,
        )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(_message,
                style: TextStyle(fontSize: 50, color: Colors.white),
                textAlign: TextAlign.start),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: TextButton(onPressed: () {
                _launchYoutubeUrl();
              }, child: const Text("Click here to open a youtube video showing how the app works", style: TextStyle(fontSize: 30), textAlign: TextAlign.start)),
            )
        ],),
      ),
    );
  }

  Future<void> _launchYoutubeUrl() async {
    Uri url = Uri.parse(_youtubeUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

}

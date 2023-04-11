import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import 'package:url_launcher/url_launcher.dart';

class YoutubePage extends StatefulWidget {

  YoutubePage({Key? key, required this.database}) : super (key: key);
  SleepData database;

  @override
  _YoutubePageState createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YouTube Videos"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            children: <Widget>[

                //Used example from https://code.tutsplus.com/tutorials/how-to-create-lists-in-your-app-with-flutter--cms-36937
                          //by Arooha Arif for reference about making list
              ListTile(
                  leading: InkWell(
                    onTap: () => _launchUrl(Uri.parse('https://youtu.be/P1mVmRxMMak')),
                    child: Icon(Icons.play_arrow),
                  ),
                  title: Text("Healthy Sleep"), //Option 1 stack overflow solution provided by user
                  subtitle:                     // Zimes for finding a way to using list tiles and inkwells
                  Column(                       //https://stackoverflow.com/questions/62257275/how-to-handle-right-overflowed-inside-listtile-flutter
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "AASM video explaining the science behind healthy sleep ",
                          ),
                        ],
                      ),
                    ],
                  ),
              ),
              ListTile(
                leading: InkWell(
                  onTap: () => _launchUrl(Uri.parse('https://youtu.be/uckGbixdXgs')),
                  child: Icon(Icons.play_arrow),
                ),
                title: Text("Improving Sleep"),
                subtitle:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "AASM video detailing methods for improving the quality of your sleep",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: InkWell(
                  onTap: () => _launchUrl(Uri.parse('https://youtu.be/FPifL8-f5m0')),
                  child: Icon(Icons.play_arrow),
                ),
                title: Text("Sleep and Wellness"),
                subtitle:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "AASM video describing the direct correlation between sleep and personal wellness",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Insert the build within here
            ],
          )
      ),
    );

  }
  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }




}
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
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
          child: Column(
            children: <Widget>[

                //Used example from https://code.tutsplus.com/tutorials/how-to-create-lists-in-your-app-with-flutter--cms-36937
                          //by Arooha Arif for reference about making list
              Padding(padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
              child: Container(
                  height: 75,
                  color: Colors.deepPurple,
                  child: ListTile(
                  leading: InkWell(
                    onTap: () => _launchUrl(Uri.parse('https://youtu.be/P1mVmRxMMak')),
                    child: Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  title: Text("Healthy Sleep", style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white)), //Option 1 stack overflow solution provided by user
                  subtitle:                     // Zimes for finding a way to using list tiles and inkwells
                  Column(                       //https://stackoverflow.com/questions/62257275/how-to-handle-right-overflowed-inside-listtile-flutter
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "AASM video explaining the science behind \nhealthy sleep ", style: const TextStyle(
                              color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
              )
              ),
      ),
      Padding(padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
          child: Container(
            height: 75,
            color: Colors.deepPurple,
            child: ListTile(
                leading: InkWell(
                  onTap: () => _launchUrl(Uri.parse('https://youtu.be/uckGbixdXgs')),
                  child: Icon(Icons.play_arrow, color: Colors.white),
                ),
                title: Text("Improving Sleep", style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
                subtitle:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "AASM video detailing methods for improving\nthe quality of your sleep", style: const TextStyle(
                            color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
          ),
      ),
      Padding(padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
          child: Container(
            height: 75,
            color: Colors.deepPurple,
            child: ListTile(
                leading: InkWell(
                  onTap: () => _launchUrl(Uri.parse('https://youtu.be/FPifL8-f5m0')),
                  child: Icon(Icons.play_arrow, color: Colors.white),
                ),
                title: Text("Sleep and Wellness", style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
                subtitle:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "AASM video describing the direct correlation\nbetween sleep and personal wellness", style: const TextStyle(
                            color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
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
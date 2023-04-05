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

              ListTile(   //Used example from https://code.tutsplus.com/tutorials/how-to-create-lists-in-your-app-with-flutter--cms-36937
                          //by Arooha Arif for reference about making list
              leading:InkWell(
              onTap: () => launchUrl(Uri.parse('https://youtu.be/P1mVmRxMMak')),
              child : Text(''),

              )
          //title: Text(''),
              ),
              ListTile(
                title: Text(''),
              ),
              ListTile(
                title: Text(''),
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import 'package:units/widgetaudioplayer.dart';

class SoundsPage extends StatefulWidget {

  SoundsPage({Key? key, required this.database}) : super (key: key);
  SleepData database;

  @override
  _SoundsPageState createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage>  {
  List<WidgetAudioPlayer> players = [];
  List<Widget> displayables = [];


  @override
  void initState() {
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud)));
    players.add(WidgetAudioPlayer("One", "test_two.mp3", Icon(Icons.sunny)));
    for(int i = 0; i < players.length; i++)
      {
        displayables.add(players[i].toWidget());
      }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep Sounds"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            children: displayables,
          )
      ),
    );
  }
}
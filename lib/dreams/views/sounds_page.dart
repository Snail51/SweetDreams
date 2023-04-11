import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import 'package:units/widgetaudioplayer.dart';
import 'dart:async';

class SoundsPage extends StatefulWidget {

  SoundsPage({Key? key, required this.database}) : super (key: key);
  SleepData database;

  @override
  _SoundsPageState createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {
  List<WidgetAudioPlayer> players = [];
  List<Widget> displayables = [];


  void update()
  {
    setState(() {
      List<Widget> holder = [];
      for (int i = 0; i < players.length; i++) {
        if(players[i].needsUpdating)
          {
            holder.add(players[i].toWidget());
            players[i].needsUpdating = false;
          }
        else
          {
            holder.add(displayables[i]);
          }
      }
      displayables = holder;
    });
  }

  @override
  void initState() {
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud, color: Colors.white)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny, color: Colors.white)));
    update();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final periodicTimer = Timer.periodic(
      const Duration(milliseconds: 200),
          (timer) {
        update();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep Sounds"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
          child: GridView.count(
              crossAxisCount: 3,
            children: displayables,
          )
      ),
    );
  }
}
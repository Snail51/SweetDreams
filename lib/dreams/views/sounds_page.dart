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
      displayables = [];
      for (int i = 0; i < players.length; i++) {
        displayables.add(players[i].toWidget());
      }
    });
  }

  @override
  void initState() {
    players.add(WidgetAudioPlayer("One", "test_one.mp3", Icon(Icons.cloud)));
    players.add(WidgetAudioPlayer("Two", "test_two.mp3", Icon(Icons.sunny)));
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
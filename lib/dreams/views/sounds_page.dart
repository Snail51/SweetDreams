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
    players.add(WidgetAudioPlayer("Summer Night", "Summer_Night.mp3", Icon(Icons.wb_twighlight)));
    players.add(WidgetAudioPlayer("Rain", "Rain.mp3", Icon(Icons.wb_cloudy)));
    players.add(WidgetAudioPlayer("Wind", "Wind.mp3", Icon(Icons.wind_power)));
    players.add(WidgetAudioPlayer("Womb", "Womb.mp3", Icon(Icons.favorite)));
    players.add(WidgetAudioPlayer("Brook", "Brook.mp3", Icon(Icons.water)));
    players.add(WidgetAudioPlayer("Ocean", "Ocean.mp3", Icon(Icons.tsunami)));
    players.add(WidgetAudioPlayer("Bird", "Bird.mp3", Icon(Icons.airplanemode_active)));
    players.add(WidgetAudioPlayer("Seagull", "Seagull.mp3", Icon(Icons.beach_access)));
    players.add(WidgetAudioPlayer("Bouy", "Bouy.mp3", Icon(Icons.directions_boat)));
    players.add(WidgetAudioPlayer("Thunder", "Thunder.mp3", Icon(Icons.bolt)));

    update();
    super.initState();
  }

  void killAll()
  {
    for(int i = 0; i < players.length; i++)
      {
        players[i].player.stop();
      }
    players = [];
  }

  @override
  Widget build(BuildContext context) {

    final periodicTimer = Timer.periodic(
      const Duration(milliseconds: 200),
          (timer) {
        update();
      },
    );

    return WillPopScope(
      onWillPop: () async {
        killAll();
        return true;
      },
      child: Scaffold(
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
      ),);
  }
}
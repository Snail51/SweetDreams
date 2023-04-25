import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import 'package:units/widgetaudioplayer.dart';
import 'dart:async';

class SoundsPage extends StatefulWidget {

  SoundsPage({Key? key, required this.soundsLoaded}) : super (key: key);
  bool soundsLoaded;

  @override
  _SoundsPageState createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {
  List<WidgetAudioPlayer> players = [];
  List<Widget> displayables = [];

  DateTime loadEnd = DateTime.now().add(Duration(seconds: 10));
  Timer refreshTimer = Timer.periodic(Duration(hours: 2), (timer) { });
  Timer loadingTimer = Timer(Duration(hours: 2), () { });
  Widget loadHolder = Text("NULL");
  bool loading = true;
  double loadingProgress = 0;


  void update()
  {
    //print(widget.soundsLoaded);
    if(!refreshTimer.isActive)
      {
        refreshTimer.cancel();
        loadingTimer.cancel();
        return;
      }
    if((refreshTimer.isActive && !loading) || (refreshTimer.isActive && widget.soundsLoaded)) {
      setState(() {
        List<Widget> holder = [];
        for (int i = 0; i < players.length; i++) {
          if (players[i].needsUpdating) {
            holder.add(players[i].toWidget());
            players[i].needsUpdating = false;
          }
          else {
            holder.add(displayables[i]);
          }
        }
        displayables = holder;
      });
    }
    if(loading && !widget.soundsLoaded)
      {
        setState(() {
          loadingProgress = 1.0 - (DateTimeRange(start: DateTime.now(), end: loadEnd).duration.inSeconds.toDouble() / 10.0);
          loadHolder = loader();
        });
      }
  }

  Widget loader() {
    //print("producing new loader with value " + loadingProgress.toString());
    return Padding(padding: EdgeInsets.all(25.0), child: Container(
      height: 250,
      width: 250,
      color: Colors.deepPurple,
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10.0), child: Text("Loading Sounds...", style: TextStyle(color: Colors.white, fontSize: 24))),
          Padding(padding: EdgeInsets.all(10.0), child: SizedBox(height: 125, width: 125, child: CircularProgressIndicator(value: loadingProgress, color: Colors.white, strokeWidth: 10.0,))),
          Padding(padding: EdgeInsets.all(10.0), child: Text("Fun Fact...", style: TextStyle(color: Colors.white, fontSize: 24))),
        ],
      ),
    ));
  }

  @override
  void initState() {

    loading = true;
    loadingProgress = 0.0;
    final loadingTimer = Timer(
        DateTimeRange(start: DateTime.now(), end: loadEnd).duration,
        () {
          loading = false;
          loadHolder = Container(
            width: 10,
            height: 10,
          );
          widget.soundsLoaded = true;

        }
    );

    final refreshTimer = Timer.periodic(
      const Duration(milliseconds: 100),
          (timer) {
        update();
      },
    );

    players.add(WidgetAudioPlayer("Summer Night", "Summer_Night.mp3", Icon(Icons.wb_twighlight, color: Colors.white)));
    players.add(WidgetAudioPlayer("Rain", "Rain.mp3", Icon(Icons.wb_cloudy, color: Colors.white)));
    players.add(WidgetAudioPlayer("Wind", "Wind.mp3", Icon(Icons.wind_power, color: Colors.white)));
    players.add(WidgetAudioPlayer("Womb", "Womb.mp3", Icon(Icons.favorite, color: Colors.white)));
    players.add(WidgetAudioPlayer("Brook", "Brook.mp3", Icon(Icons.water, color: Colors.white)));
    players.add(WidgetAudioPlayer("Ocean", "Ocean.mp3", Icon(Icons.tsunami, color: Colors.white)));
    players.add(WidgetAudioPlayer("Bird", "Bird.mp3", Icon(Icons.notification_important, color: Colors.grey)));
    players.add(WidgetAudioPlayer("Seagull", "Seagull.mp3", Icon(Icons.beach_access, color: Colors.grey)));
    players.add(WidgetAudioPlayer("Bouy", "Bouy.mp3", Icon(Icons.directions_boat, color: Colors.grey)));
    players.add(WidgetAudioPlayer("Thunder", "Thunder.mp3", Icon(Icons.bolt, color: Colors.grey)));

    update();
    super.initState();
  }

  void killAll()
  {
    refreshTimer.cancel();
    loadingTimer.cancel();
    print("consuming timer " + refreshTimer.toString());
    for(int i = 0; i < players.length; i++)
      {
        players[i].player.stop();
        players[i].needsUpdating = false;
      }
    players = [];
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
       onWillPop: () async {
        killAll();
        // timer.cancel
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
          child: Column(
            children: <Widget>[
              loadHolder,
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: displayables,
                ),
              ),
            ],
          ),
        )
      ));
  }
}
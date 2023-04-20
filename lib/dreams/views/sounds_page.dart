import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import 'package:units/widgetaudioplayer.dart';
import 'dart:async';
import '../utils/sleep_facts.dart';

class SoundsPage extends StatefulWidget {

  SoundsPage({Key? key, required this.soundsLoaded}) : super (key: key);
  bool soundsLoaded;

  @override
  _SoundsPageState createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {
  List<WidgetAudioPlayer> players = [];
  List<Widget> displayables = [];

  DateTime loadEnd = DateTime.now().add(Duration(seconds: 20));
  Timer refreshTimer = Timer.periodic(Duration(hours: 2), (timer) { });
  Timer loadingTimer = Timer(Duration(hours: 2), () { });
  Widget loadHolder = Text("NULL");
  bool loading = true;
  double loadingProgress = 0;

  Widget funHolder = Text("NULL");
  FactContainer fun = FactContainer();


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
          loadingProgress = 1.0 - (DateTimeRange(start: DateTime.now(), end: loadEnd).duration.inSeconds.toDouble() / 20.0);
          loadHolder = loader();
        });
      }
  }

  Widget loader() {
    //print("producing new loader with value " + loadingProgress.toString());
    return Padding(padding: EdgeInsets.all(25.0), child: Container(
      height: 400,
      width: 250,
      color: Colors.deepPurple,
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10.0), child: Text("Loading Sounds...", style: TextStyle(color: Colors.white, fontSize: 24))),
          Padding(padding: EdgeInsets.all(10.0), child: SizedBox(height: 125, width: 125, child: CircularProgressIndicator(value: loadingProgress, color: Colors.white, strokeWidth: 10.0,))),
          Center(child: Padding(padding: EdgeInsets.all(10.0), child: funHolder)),
        ],
      ),
    ));
  }

  @override
  void initState() {

    funHolder = fun.getFactContainer();

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

    players.add(WidgetAudioPlayer("Morning Meadow", "meadow_morning.mp3", Icon(Icons.agriculture))); //SBA
    players.add(WidgetAudioPlayer("Bird", "Bird.mp3", Icon(Icons.notification_important))); //DEX
    players.add(WidgetAudioPlayer("Sparrows", "sparrows.mp3", Icon(Icons.forest))); //SBA
    players.add(WidgetAudioPlayer("Dogs Barking", "dogs_barking.mp3", Icon(Icons.pets))); //SBA

    players.add(WidgetAudioPlayer("Summer Night", "Summer_Night.mp3", Icon(Icons.wb_twighlight))); //DEX
    players.add(WidgetAudioPlayer("Leaves Crunching", "dry_leaves.mp3", Icon(Icons.park))); //SBA

    players.add(WidgetAudioPlayer("Rain", "Rain.mp3", Icon(Icons.wb_cloudy))); //DEX
    players.add(WidgetAudioPlayer("Rain on Window", "rain_on_glass.mp3", Icon(Icons.window))); //SBA
    players.add(WidgetAudioPlayer("Thunder", "Thunder.mp3", Icon(Icons.bolt))); //DEX

    players.add(WidgetAudioPlayer("Brook", "Brook.mp3", Icon(Icons.water))); //DEX

    players.add(WidgetAudioPlayer("Ocean", "Ocean.mp3", Icon(Icons.tsunami))); //DEX
    players.add(WidgetAudioPlayer("Seagull", "Seagull.mp3", Icon(Icons.beach_access))); //DEX
    players.add(WidgetAudioPlayer("Bouy", "Bouy.mp3", Icon(Icons.directions_boat))); //DEX
    players.add(WidgetAudioPlayer("Rowboat", "paddle_rowing.mp3", Icon(Icons.rowing))); //SBA

    players.add(WidgetAudioPlayer("Industry", "industrial_transport.mp3", Icon(Icons.factory))); //SBA
    players.add(WidgetAudioPlayer("Distant City", "distant_city.mp3", Icon(Icons.location_city))); //SBA
    players.add(WidgetAudioPlayer("Powerplant", "power_generator.mp3", Icon(Icons.electric_bolt))); //SBA
    players.add(WidgetAudioPlayer("Wind", "Wind.mp3", Icon(Icons.wind_power))); //DEX
    players.add(WidgetAudioPlayer("Wind Farm", "wind_turbines.mp3", Icon(Icons.wind_power))); //SBA

    players.add(WidgetAudioPlayer("Typing", "keyboard_typing.mp3", Icon(Icons.keyboard))); //SBA
    players.add(WidgetAudioPlayer("Bullet Train", "train_fast.mp3", Icon(Icons.directions_train))); //SBA
    players.add(WidgetAudioPlayer("Library", "books.mp3", Icon(Icons.book))); //SBA

    players.add(WidgetAudioPlayer("Music Box", "music_box.mp3", Icon(Icons.bedroom_baby))); //SBA
    players.add(WidgetAudioPlayer("Campanile Bells", "campanile_bells.mp3", Icon(Icons.notifications))); //SBA
    players.add(WidgetAudioPlayer("Large Bell", "large_bell.mp3", Icon(Icons.circle_notifications))); //SBA
    players.add(WidgetAudioPlayer("Church Bells", "church_bells.mp3", Icon(Icons.church))); //SBA

    players.add(WidgetAudioPlayer("Brown Noise", "brown_noise.mp3", Icon(Icons.multitrack_audio))); //SBA
    players.add(WidgetAudioPlayer("Pink Noise", "pink_noise.mp3", Icon(Icons.multitrack_audio))); //SBA
    players.add(WidgetAudioPlayer("Rolling Ball", "ball_rolling.mp3", Icon(Icons.sports_basketball))); //SBA
    players.add(WidgetAudioPlayer("Womb", "Womb.mp3", Icon(Icons.favorite))); //DEX



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
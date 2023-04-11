import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';


class WidgetAudioPlayer
{
  bool isPlaying = false;
  String source = "";
  String name = "";
  Icon icon = Icon(Icons.question_mark);
  Color buttonColor = Colors.white70;
  double volume = 1.0;
  final AudioPlayer player = AudioPlayer();
  bool needsUpdating = true;

  WidgetAudioPlayer(String Name, String srcdir, Icon display)
  {
    icon = display;
    source = srcdir;
    name = Name;
    isPlaying = false;
    buttonColor = Colors.white70;
    volume = 1.0;


    player.pause();
    player.setReleaseMode(ReleaseMode.LOOP);
    player.setVolume(volume);
    setAudio();
  }

  Future setAudio() async
  {
    final localAudioCache = AudioCache(prefix: "assets/audiosrc/");
    final url = await localAudioCache.load(source);
    player.setUrl(url.path, isLocal: true);
  }

  void toggle()
  {
    needsUpdating = true;
    isPlaying = !isPlaying;
    if(isPlaying)
    {
      player.resume();
    }
    else
    {
      player.stop();
    }
  }

  void updateVolume(double newVol)
  {
    needsUpdating = true;
    volume = newVol;
    player.setVolume(volume);
  }


  Widget toWidget()
  {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          color: Colors.amber,
          height: 150,
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(name),
              IconButton(onPressed: toggle, icon: icon),
              Slider(
                value: volume, onChanged: updateVolume, min: 0, max: 1, label: volume.toString(),)
            ],
          ),
        )
    );
  }

}
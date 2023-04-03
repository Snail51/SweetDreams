import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';


class WidgetAudioPlayer
{
  bool isPlaying = false;
  String source = "";
  String name = "";
  Icon icon = Icon(Icons.question_mark);
  Color buttonColor = Colors.white70;
  double volume = 100;
  final AudioPlayer player = AudioPlayer();

  WidgetAudioPlayer(String Name, String srcdir, Icon display)
  {
    icon = display;
    source = srcdir;
    name = Name;
    isPlaying = false;
    buttonColor = Colors.white70;
    volume = 100;


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
    volume = newVol;
  }


  Widget toWidget()
  {
    return Container(
      color: Colors.blueAccent,
      height: 100,
      width: 100,
      child: Column(
        children: <Widget>[
          Text(name),
          IconButton(onPressed: toggle, icon: icon),
          Slider(value: volume, onChanged: updateVolume, min: 0, max: 100,)
        ],
      ),
    );
  }

}
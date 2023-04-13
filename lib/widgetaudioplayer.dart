import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';


class WidgetAudioPlayer
{
  bool isPlaying = false;
  String source = "";
  String name = "";
  Icon icon = Icon(Icons.question_mark, color: Colors.red); //obvious init to find erros
  Color buttonColor = Colors.grey;
  double volume = 0.5;
  final AudioPlayer player = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  bool needsUpdating = true;

  WidgetAudioPlayer(String Name, String srcdir, Icon display)
  {
    icon = display;
    buttonColor = Colors.grey;
    icon = Icon(icon.icon, color: buttonColor);
    source = srcdir;
    name = Name;
    isPlaying = false;
    volume = 0.5;


    player.setReleaseMode(ReleaseMode.LOOP);
    player.setVolume(volume);
    setAudio();
  }

  Future setAudio() async
  {
    final localAudioCache = AudioCache(prefix: "assets/audiosrc/");
    final url = await localAudioCache.load(source);
    player.setUrl(url.path, isLocal: true);
    player.stop();
  }

  void toggle()
  {
    needsUpdating = true;
    isPlaying = !isPlaying;
    if(isPlaying)
    {
      player.resume();
      buttonColor = Colors.white;
    }
    else
    {
      player.stop();
      buttonColor = Colors.grey;
    }
    icon = Icon(icon.icon, color: buttonColor);
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
          color: Colors.deepPurple,
          height: 150,
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(name,
              style: TextStyle(color: Colors.white),
              ),
              IconButton(onPressed: toggle, icon: icon),
              SliderTheme(data: SliderThemeData(
                  thumbColor: Colors.white,
                  activeTrackColor: Colors.white
              ),
                  child: Slider(
                    value: volume, onChanged: updateVolume, min: 0, max: 1, label: volume.toString(),))
            ],
          ),
        )
    );
  }

}
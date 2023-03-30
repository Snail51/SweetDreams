import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SleepEvent {
  int eventNumber = 0;
  DateTime sleep = DateTime.now();
  DateTime wake = DateTime.now();
  int quality = 0; // 1-5 scale
  String dream = ""; // "" if none given

  SleepEvent(int num, DateTime start, {DateTime? end, int? Quality = 0, String? Dream = ""})
  {
    eventNumber = num;
    sleep = start;
    if(end == null)
    {
      wake = DateTime.now();
    }
    else
    {
      wake = end;
    }
    quality = Quality!;
    //print("Quality Added: " + quality.toString());
    //print("Event Created");
    dream = Dream!;
    //print("Dream: " + dream!);
  }

  void set({int? num, DateTime? start, DateTime? end, int? quality, String? dream}) // dynamic setter.
  {
    if(num != null)
      {
        eventNumber = num;
      }
    if(start != null)
      {
        sleep = start;
      }
    if(end != null)
      {
        wake = end;
      }
    if((quality != null)&&(quality >= 1)&&(quality <= 5))
      {

        quality = quality;
      }
    if(dream != null)
      {
        dream = dream;
      }

  }

  @override
  String toString() { //Produces string representation of object
    String composite = "";
    composite += "--------------------------\n";
    composite += "Sleep: " + eventNumber.toString() + "\n";
    composite += "Went to sleep at: " + sleep.toString() + "\n";
    composite += "Woke up at: " + wake.toString() + "\n";

    composite += "Your rating of the quality of your Sleep: ";
    if(quality == 0)
      {
        composite += "Not Given\n";
      }
    else
      {
        composite += quality.toString() + "\n";
      }

    composite += "---------------------------\n";
    composite += "Dreams you had that night:\n";
    if(dream == "")
      {
      composite += "\tNone.\n";
      }
    else
      {
        composite += "\t" + dream + "\n";
      }

    composite += "=======================\n";

    return composite;
  }

  Widget toWidget()
  {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Colors.blueAccent,
                child: Padding(padding: EdgeInsets.all(5), child: Column(
                  children: <Widget>[
                    Text(DateFormat.MMMd().format(sleep) + ", " + DateFormat.y().format(sleep),overflow: TextOverflow.visible),
                    Text(DateFormat.jm().format(sleep),overflow: TextOverflow.visible),
                  ],
                )),
              ),
              Container(
                color: Colors.blueAccent,
                child: Padding(padding: EdgeInsets.all(5), child: Column(
                  children: <Widget>[
                    Text(DateFormat.MMMd().format(wake) + ", " + DateFormat.y().format(wake),overflow: TextOverflow.visible),
                    Text(DateFormat.jm().format(wake),overflow: TextOverflow.visible),
                  ],
                )),
              ),
            ],
          ),
          Text("Quality: " + quality.toString(),overflow: TextOverflow.visible),
          Text("Dream Log:\n\t" + dream.toString(),overflow: TextOverflow.visible),
        ]
    ));
  }
} //END OF CLASS SleepEvent

class SleepData {

  List<SleepEvent> database = []; // List containing all data via SleepEvents

  SleepData({String? filename})
  {
    database = [];

    if (filename != null) {
      _read(filename);
    }
  }

  Future<String> _read(dir) async {
    String text = "";
    //print("READING");
    try {

      final Directory directory = await getApplicationDocumentsDirectory();

      //print(directory.toString());
      final File file = File('${directory.path}/$dir');


      text = await file.readAsString();

      //print("file Content read: " + text);

      //OPEN THE FILE
      final entries = text.split('\n');
      int length = entries.length;
      //print("Entries in file: "+ length.toString());

      for(int i=0; i < length; i++) {
        if ((i != length - 1)) {
          //print("Entry[" +i.toString() + "]: " + entries[i]);
          final line = entries[i].split(',');
          int index = int.parse(line[0]);
          DateTime start = DateTime.parse(line[1]);
          DateTime end = DateTime.parse(line[2]);
          int qual = int.parse(line[3]);
          String dream = line[4];
          addEvent(start, wake:end, quality:qual, dream:dream);
        }
        //print("Found File (_read) \n" + '${directory.path}/$dir');
      }
      //WHILE HAS NOT REACHED EOF, ADVANCE ONE LINE
      //extract event Int from substr
      //extract sleep DateTime from substr
      //extract wake DateTime from substr
      //extract quality Int from substr
      //extract dream string from substr
      //database.add(start, end, qual, dream);
      //goto start of while

    } catch (e) {
      print("Couldn't read file (_read)");
    }
    return text;
  }

  void addEvent(DateTime sleep, {DateTime? wake = null, int? quality = 0, String? dream = ""}) //adds a sleep event at the last index of the database. A DateTime for the start of the sleep is required but other parameters are optional and will default.
  {
    database.add(SleepEvent(database.length, sleep, end: wake, Quality: quality, Dream: dream));

  }

  SleepEvent? delEvent(int index) //Deletes the event at the specified index, returning it. Returns null if no such event exists
  {
    if ((database.length - 1 < index) && (index >= 0))
    {
      return null;
    }

    SleepEvent holder = database[index];
    database.removeAt(index);
    return holder;
  }

  int editEvent(int index, {DateTime? start, DateTime? end, int? quality, String? dream}) // 0 - Failure, 1 - No change, 2 - Change(s) made
  {
    if ((database.length - 1 < index) && (index >= 0)) {
      return 0; //Index is not valid
    }

    int changes = 0;

    if (start != null) {
      database[index].set(start: start);
      changes++;
    }
    if (end != null) {
      database[index].set(end: end);
      changes++;
    }
    if (quality != null) {
      database[index].set(quality: quality);
      changes++;
    }
    if (dream != null) {
      database[index].set(dream: dream);
      changes++;
    }

    if (changes == 0) {
      return 1;
    }

    return 2;
  }

  List<SleepEvent> getData({int? index}) // Returns the full database list UNLESS an index is provided as an integer, in which case a list containing just that entry is returned
  {
    if(index == null)
      {
        return database;
      }
    else
      {
        List<SleepEvent> tmp = [];
        tmp.add(database[index]);
        return tmp;
      }
  }
  void save(String dir)
  {
    String writeBuffer = "";
    int len = database.length;
    for( var i = 0 ; i < len; i++ ) {
      writeBuffer += database[i].eventNumber.toString() + ",";
      writeBuffer += database[i].sleep.toString() + ",";
      writeBuffer += database[i].wake.toString() + ",";
      writeBuffer += database[i].quality.toString() + ",";
      writeBuffer += database[i].dream.toString();
      writeBuffer += "\n";
    }
    _write(writeBuffer, dir);
  }

  _write(String text, dir) async { // from https://stackoverflow.com/questions/54122850/how-to-read-and-write-a-text-file-in-flutter
    await Future.delayed(const Duration( seconds: 2), () {});
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$dir');
    await file.writeAsString(text);
    //print("saved at " + '${directory.path}/$dir');
  }


} // END OF CLASS SleepData

void main() // test func
{
  SleepData gen = SleepData(filename: "data.csv");
  gen.addEvent(DateTime.now());
  print(gen.getData()[0].toString());
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:core';

class DiaryEntry {
  int eventNumber = 0;
  DateTime timeRef = DateTime.now();
  String title = ""; // "" if none given
  String content = "";

  DiaryEntry(int num, DateTime ref, {String? Title, String? Content})
  {
    eventNumber = num;
    timeRef = ref;
    if(Title != null)
    {
      title = Title;
    }
    if(Content != null)
    {
      content = Content;
    }
  }

  void set({int? num, DateTime? Ref, String? Title, String? Content}) // dynamic setter.
  {
    if(num != null)
    {
      eventNumber = num;
    }
    if(Ref != null)
    {
      timeRef = Ref;
    }
    if(Title != null)
    {
      title = Title;
    }
    if(Content != null)
    {
      content = Content;
    }
  }

  @override
  String toString() { //Produces string representation of object
    String composite = "";
    composite += "--------------------------\n";
    composite += title + "\n";
    composite += "Entry #: " + eventNumber.toString() + "\n";
    composite += "From: " + timeRef.toString() + "\n";
    composite += "---------------------------\n";
    composite += content;
    composite += "=======================\n";

    return composite;
  }

  Widget toWidget()
  {
    return Container(child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title),
          Text(DateFormat.MMMd().format(timeRef) + ", " + DateFormat.y().format(timeRef),overflow: TextOverflow.visible, style: TextStyle(color: Colors.white)),
          Text(content.replaceRange(32, content.length, content)),
        ],
    )));
  }
} //END OF CLASS SleepEvent

class Diary {

  List<DiaryEntry> database = []; // List containing all data via SleepEvents
  String delimiter = "🂿";
  String dir = "";
  Diary({String? filename})
  {
    database = [];

    if (filename != null) {
      _read(filename);
      dir = filename;
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
          final line = entries[i].split(delimiter);
          int index = int.parse(line[0]);
          DateTime ref = DateTime.parse(line[1]);
          String title = line[2];
          String content = line[3];
          addEvent(ref, Title: title, Content: content);
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

  void addEvent(DateTime ref, {String? Title, String? Content}) //adds a sleep event at the last index of the database. A DateTime for the start of the sleep is required but other parameters are optional and will default.
  {
    database.add(DiaryEntry(database.length, ref, Title: Title, Content: Content));

  }

  DiaryEntry? delEvent(int index) //Deletes the event at the specified index, returning it. Returns null if no such event exists
  {
    if ((database.length - 1 < index) && (index >= 0))
    {
      return null;
    }

    DiaryEntry holder = database[index];
    database.removeAt(index);
    return holder;
  }

  int editEvent(int index, {DateTime? Ref, String? Title, String? Content}) // 0 - Failure, 1 - No change, 2 - Change(s) made
  {
    if ((database.length - 1 < index) && (index >= 0)) {
      return 0; //Index is not valid
    }

    /*delEvent(index);
    database.add(SleepEvent(index, start!, end: end, Quality: quality, Dream: dream));
    return 1;
    */
    int changes = 0;

    if (Ref != null) {
      database[index].set(Ref: Ref);
      changes++;
    }
    if (Title != null) {
      database[index].set(Title: Title);
      changes++;
    }
    if (Content != null) {
      database[index].set(Content: Content);
      changes++;
    }

    if (changes == 0) {
      return 1;
    }

    return 2;
  }

  List<DiaryEntry> getData({int? index}) // Returns the full database list UNLESS an index is provided as an integer, in which case a list containing just that entry is returned
  {
    if(index == null)
    {
      return database;
    }
    else
    {
      List<DiaryEntry> tmp = [];
      tmp.add(database[index]);
      return tmp;
    }
  }

  void save()
  {
    String writeBuffer = "";
    int len = database.length;
    for( var i = 0 ; i < len; i++ ) {
      writeBuffer += database[i].eventNumber.toString() + delimiter;
      writeBuffer += database[i].timeRef.toString() + delimiter;
      writeBuffer += database[i].title.toString() + delimiter;
      writeBuffer += database[i].content.toString();
      writeBuffer += "\n";
    }
    _write(writeBuffer);
  }

  _write(String text) async { // from https://stackoverflow.com/questions/54122850/how-to-read-and-write-a-text-file-in-flutter
    await Future.delayed(const Duration( seconds: 2), () {});
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$dir');
    await file.writeAsString(text);
    //print("saved at " + '${directory.path}/$dir');
  }


} // END OF CLASS SleepData

void main() // test func
{
  Diary gen = Diary(filename: "data.csv");
  gen.addEvent(DateTime.now());
  print(gen.getData()[0].toString());
}
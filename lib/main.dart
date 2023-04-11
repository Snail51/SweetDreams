import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dreams/views/sleep_log.dart';
import 'database.dart';
import 'dreams/views/newCalc.dart';
import 'dreams/views/info_page.dart';
import 'dreams/views/sounds_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String file = "data.csv";
  SleepData database = new SleepData(filename: "data.csv");

  @override
  Widget build(BuildContext context) {
    //database.addEvent(DateTime.now().subtract(Duration(hours: 3)),wake: DateTime.now().add(Duration(hours: 3)),quality: 3, dream: "Test Dream Description");
    //database.addEvent(DateTime.now().subtract(Duration(hours: 4)),wake: DateTime.now().add(Duration(hours: 2)),quality: 3, dream: "Test Dream Description");
    //database.addEvent(DateTime.now().subtract(Duration(hours: 5)),wake: DateTime.now().add(Duration(hours: 1)),quality: 4, dream: "Test Dream Description");
    return MaterialApp(
        home: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Sweet Dreams"),
              ),
              body: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Text("Sweet Dreams!",style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent), textScaleFactor: 3,)
                        ,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent
                        ),
                        child: Text('Sleep Calculator'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CalcPage(database: database)));
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent
                        ),
                        child: Text('Sleep Log'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SleepLogPage(database: database, file: file)));
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent
                        ),
                        child: Text('More Info'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => InfoPage(database: database)));
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent
                        ),
                        child: Text('Sleep Sounds'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SoundsPage(database: database)));
                        },
                      ),
                    ],
                  )
              ),
            )
        )
    );
  }
}



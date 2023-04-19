import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dreams/views/sleep_log.dart';
import 'database.dart';
import 'dreams/views/newCalc.dart';
import 'dreams/views/info_page.dart';
import 'dreams/views/sounds_page.dart';
import 'dreams/views/sleep_diary.dart';
import 'diary.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String file = "data.csv";
  SleepData database = new SleepData(filename: "data.csv");
  Diary diary = new Diary();

  @override
  Widget build(BuildContext context) {
    //database.addEvent(DateTime.now().subtract(Duration(hours: 3)),wake: DateTime.now().add(Duration(hours: 3)),quality: 3, dream: "Test Dream Description");
    //database.addEvent(DateTime.now().subtract(Duration(hours: 4)),wake: DateTime.now().add(Duration(hours: 2)),quality: 3, dream: "Test Dream Description");
    //database.addEvent(DateTime.now().subtract(Duration(hours: 5)),wake: DateTime.now().add(Duration(hours: 1)),quality: 4, dream: "Test Dream Description");
    return MaterialApp(
        home: Builder(
            builder: (context) => Scaffold(
              backgroundColor: Colors.grey.shade900,
              appBar: AppBar(
                title: Text("Sweet Dreams"),
                backgroundColor: Colors.deepPurple,
                centerTitle: true,
              ),
              body: Center(
                  child: Column(
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Text("Sweet Dreams!",style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                          textScaleFactor: 3,)
                        ,),
                      SizedBox(
                          width: 150, // <-- match_parent
                          height: 150, // <-- match-parent
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple
                            ),
                            child: Text('Sleep Calculator'),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CalcPage(database: database)));
                            },
                          ),
                      ),

                      SizedBox(
                          width: 150,
                          height: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple
                            ),
                            child: Text('Sleep Log'),
                            onPressed: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context) => SleepLogPage(database: database)));
                            },
                          ),
                      ),

                      SizedBox(
                          width: 150,
                          height: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple
                            ),
                            child: Text('Sleep Diary'),
                            onPressed: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context) => DiaryPage(diary: diary)));

                            },
                          ),
                      ),

                      SizedBox(
                          width: 150,
                          height: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple
                            ),
                            child: Text('More Info'),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => InfoPage(database: database)));
                            },
                          ),
                      ),

                      SizedBox(
                          width: 150,
                          height: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple
                            ),
                            child: Text('Sleep Sounds'),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SoundsPage(database: database)));
                            },
                          ),
                      ),
                    ],
                  )
              ),
            )
        )
    );
  }
}



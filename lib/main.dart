import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dreams/views/sleep_log.dart';
import 'database.dart';
import 'dreams/views/newCalc.dart';
import 'dreams/views/info_page.dart';
import 'dreams/views/sounds_page.dart';
import 'dreams/views/sleep_diary.dart';
import 'diary.dart';
import 'dreams/utils/sleep_facts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String logFile = "sleepLogData.🂿sv";
  String diaryFile = "diaryData.🂿sv";
  Diary diary = new Diary(filename: "diaryData.🂿sv");
  SleepData database = new SleepData(filename: "sleepLogData.🂿sv");
  bool soundsLoaded =
      false; // has the sounds page been navigated to and fully loaded at least once?
  FactContainer fun = FactContainer();

  @override
  Widget build(BuildContext context) {
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
                        child: Text(
                          "Sweet Dreams!",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                          textScaleFactor: 3,
                        ),
                      ),
                      Row(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 35, right: 20, top: 20, bottom: 20),
                          child: SizedBox(
                            width: 150, // <-- match_parent
                            height: 150, // <-- match-parent
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple),
                              child: Text('Sleep Calculator'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CalcPage(database: database)));
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple),
                              child: Text('Sleep Log'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SleepLogPage(database: database)));
                              },
                            ),
                          ),
                        )
                      ]),
                      Row(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 35, right: 20, top: 20, bottom: 20),
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple),
                              child: Text('Sleep Diary'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DiaryPage(diary: diary)));
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple),
                              child: Text('More Info'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InfoPage(database: database)));
                              },
                            ),
                          ),
                        )
                      ]),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple),
                            child: Text('Sleep Sounds'),
                            onPressed: () async {
                              //wait for page to exit before setting "soundsLoaded" to ture
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SoundsPage(soundsLoaded: soundsLoaded),
                                  ));
                              soundsLoaded = true;
                            },
                          ),
                        ),
                      ),
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          color: Colors.deepPurple,
                          child: Text(
                            "Fun Fact: " + fun.getRandomFact().toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        )
                    ],
                  ),

                  ),
                )));
  }
}

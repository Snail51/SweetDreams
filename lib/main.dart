import 'package:flutter/material.dart';

import 'dreams/views/dreams_component.dart';
import 'dreams/views/sleep_log.dart';
import 'dreams/presenter/dreams_presenter.dart';
import 'dreams/views/sleep_planner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return SplashScreen();
                    }));
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent
                  ),
                  child: Text('Sleep Log'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return SleepLogScreen();
                    }));
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent
                  ),
                  child: Text('Sleep Planner'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return SleepPlannerScreen();
                    }));
                  },
                )
              ],
            )
          ),
        )
      )
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return new HomePage(new BasicPresenter(), title: 'Sweet Dreams', key: Key("UNITS"),);
  }
}

class SleepLogScreen extends StatefulWidget {
  @override
  _SleepLogScreen createState() => _SleepLogScreen();
}

class _SleepLogScreen extends State<SleepLogScreen> {
  @override
  Widget build(BuildContext context) {
    return new SleepLogPage(new BasicPresenter(), title: 'Sleep Log', key: Key("UNITS"),);
  }
}

class SleepPlannerScreen extends StatefulWidget {
  @override
  _SleepPlannerScreen createState() => _SleepPlannerScreen();
}

class _SleepPlannerScreen extends State<SleepPlannerScreen> {
  @override
  Widget build(BuildContext context) {
    return new SleepPlannerPage(new BasicPresenter(), title: 'Sleep Planner', key: Key("UNITS"),);
  }
}
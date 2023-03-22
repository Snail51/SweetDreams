import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../views/dreams_view.dart';
import '../presenter/dreams_presenter.dart';

class SleepPlannerPage extends StatefulWidget {
  final UNITSPresenter presenter;

  SleepPlannerPage(this.presenter, {required Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _SleepPlannerPageState createState() => _SleepPlannerPageState();
}

class _SleepPlannerPageState extends State<SleepPlannerPage>  {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Sleep Planner"),
              ),
              body: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Text("Sleep Planner", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent), textScaleFactor: 3,)
                      ),
                    ],
                  )
              ),
            )
        )
    );
  }
}
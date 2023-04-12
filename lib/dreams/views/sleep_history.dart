
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';

class SleepHistory extends StatefulWidget {

  SleepHistory({Key? key, required this.database}) : super (key: key);
  SleepData database;

  @override
  _SleepHistoryState createState() => _SleepHistoryState();
}

class _SleepHistoryState extends State<SleepHistory>  {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep History"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
          child: Column(
            children: <Widget>[
              //Insert the build within here
            ],
          )
      ),
    );
  }
}

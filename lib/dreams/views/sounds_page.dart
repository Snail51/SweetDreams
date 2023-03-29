import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';

class SoundsPage extends StatefulWidget {

  SoundsPage({Key? key, required this.database}) : super (key: key);
  SleepData database;

  @override
  _SoundsPageState createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage>  {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep Sounds"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.white,
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
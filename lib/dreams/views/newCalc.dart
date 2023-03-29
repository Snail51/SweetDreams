import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/dreams_constant.dart';
import 'package:units/database.dart';
import 'package:time_range_picker/time_range_picker.dart';


class HomePage extends StatefulWidget {

  HomePage({Key? key, required this.database}) : super (key: key);

  SleepData database;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  void _timePicker() {
    showTimeRangePicker(
      context: context,
    );
  }


  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: _timePicker,
          child: const Padding(
            padding: EdgeInsets.all(.0),
            child: Text('Pick a time to sleep',
                style: TextStyle(color: Colors.white, fontSize: 30)),
          ),
          color: Colors.blue,
        ),
      ),
    );
  }
}







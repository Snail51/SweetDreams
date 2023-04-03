import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import 'package:time_range_picker/time_range_picker.dart';


class CalcPage extends StatefulWidget {
  CalcPage({Key? key, required this.database}) : super (key: key);


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  SleepData database = new SleepData(filename: "data.csv");

  @override
  _CalcPageState createState() => _CalcPageState();
}


class _CalcPageState extends State<CalcPage> {

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 3)));
  double cycle = 90.00;
  double value = 16;
  List<Widget> modes = [];


  @override
  void initState() {
    /**
    modes += modeWake();
    modes += modeSleep();
    modes += modeCycles();
     */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Calculator'),
      ),
      body:
        Expanded(child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index)
          {
          return Container
            (
              color: Colors.blueAccent,
              child: modes[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          addAutomaticKeepAlives: false,
        )),
      );
  }
}









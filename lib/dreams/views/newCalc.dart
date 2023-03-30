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
  SleepData database = new SleepData("data.csv");

  @override
  _CalcPageState createState() => _CalcPageState();
}


class _CalcPageState extends State<CalcPage> {

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 3)));
  double cycle = 90.00;
  double value = 16;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Calculator'),
      ),
      body: ListView(children: [
        Slider(
          value: value,
          label: value.round().toString(),
          activeColor: Colors.red,
          inactiveColor: Colors.red.shade100,
          min: 0,
          max: 16,
          divisions: 16,
          onChanged: (value) => setState(() => this.value = value),
      ),
        ElevatedButton(
          onPressed: () async {
            TimeRange? result = await showTimeRangePicker(
              context: context,
              rotateLabels: false,
              ticks: 12,
              ticksColor: Colors.grey,
              ticksOffset: -12,
              labels: [
                "24 ",
                "3 ",
                "6 ",
                "9 ",
                "12 ",
                "15 ",
                "18 ",
                "21 "
              ].asMap().entries.map((e) {
                return ClockLabel.fromIndex(
                    idx: e.key, length: 8   , text: e.value);
              }).toList(),
              labelOffset: -30,
              padding: 55,
              start: const TimeOfDay(hour: 12, minute: 0),
              end: const TimeOfDay(hour: 18, minute: 0),
              /**
              disabledTime: TimeRange(
                startTime: const TimeOfDay(hour: 4, minute: 0),
                endTime: const TimeOfDay(hour: 10, minute: 0),
              ),
                  **/
              maxDuration: const Duration(hours: 6),
            );

            if (kDebugMode) {
              print("result $result");
            }
          },
          child: const Text("Sleep Cycle"),
        ),
      ]),
    );
  }
}









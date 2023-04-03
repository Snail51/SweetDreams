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
  double cycleLength = 90.00;
  double maxSleepCycle = 16;
  double? cycles;
  DateTime? fixedWake;
  DateTime? fixedSleep;
  DateTime? bestSleepTime;
  DateTime? bestWakeTime;
  String _selectedPeriod = 'AM';

  @override
  void initState() {
    super.initState();
  }

  Widget modeWake() {
    final now = DateTime.now();
    final sleepCycle = 90;
    final maxCycles = 16;
    final cycleLength = Duration(minutes: sleepCycle);
    DateTime? fixedWake;
    DateTime? bestSleepTime;
    DateTime? bestWakeTime;

    void updateWakeTime(TimeOfDay time) {
      fixedWake = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      bestSleepTime = fixedWake!.subtract(cycleLength * maxCycles);
      bestWakeTime = fixedWake;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Fixed Wake Time:'),
        ElevatedButton(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              setState(() {
                updateWakeTime(picked);
              });
            }
          },
          child: Text('Select Time'),
        ),
        if (fixedWake != null) ...[
          SizedBox(height: 16),
          Text('Selected Wake Time: ${fixedWake!.format(context)}'),
          SizedBox(height: 16),
          Text('Select Wakeup time range:'),
          TimeRangePicker(
            startTime: fixedWake!,
            endTime: fixedWake!.add(Duration(hours: 6)),
            interval: Duration(minutes: 30),
            onRangeChanged: (start, end) {
              // Check if the user is trying to turn clockwise
              if (end.isAfter(fixedWake!) || end == fixedWake!) {
                // If so, set the end time to the maximum allowed time (6 hours after the wake time)
                setState(() {
                  end = fixedWake!.add(Duration(hours: 6));
                });
              }
              setState(() {
                // Set the start time to the closest multiple of the sleep cycle before the end time
                final cyclesCount = ((end.difference(fixedWake!) - cycleLength) / cycleLength).floor();
                start = end.subtract(cycleLength * cyclesCount);
                updateWakeTime(start);
              });
            },
          ),
        ],
      ],
    );
  }

  Widget modeSleep() {
    final now = DateTime.now();
    final sleepCycle = 90;
    final maxCycles = 16;
    final cycleLength = Duration(minutes: sleepCycle);
    DateTime? fixedSleep;
    DateTime? bestSleepTime;
    DateTime? bestWakeTime;

    void updateSleepTime(TimeOfDay time) {
      fixedSleep = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      bestSleepTime = fixedSleep!.subtract(cycleLength * maxCycles);
      bestWakeTime = fixedSleep!.add(cycleLength * maxCycles);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Fixed Sleep Time:'),
        ElevatedButton(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              setState(() {
                updateSleepTime(picked);
              });
            }
          },
          child: Text('Select Time'),
        ),
        if (fixedSleep != null) ...[
          SizedBox(height: 16),
          Text('Selected Sleep Time: ${fixedSleep!.format(context)}'),
          SizedBox(height: 16),
          Text('Select Sleep time range:'),
          TimeRangePicker(
            startTime: fixedSleep!.subtract(Duration(hours: 6)),
            endTime: fixedSleep!,
            interval: Duration(minutes: 30),
            onRangeChanged: (start, end) {
              // Check if the user is trying to turn clockwise
              if (start.isBefore(fixedSleep!) || start == fixedSleep!) {
                // If so, set the start time to the minimum allowed time (6 hours before the sleep time)
                setState(() {
                  start = fixedSleep!.subtract(Duration(hours: 6));
                });
              }
              setState(() {
                // Set the end time to the closest multiple of the sleep cycle after the start time
                final cyclesCount = ((fixedSleep!.difference(start) - cycleLength) / cycleLength).floor();
                end = start.add(cycleLength * cyclesCount);
                updateSleepTime(end);
              });
            },
          ),
        ],
      ],
    );
  }
  Widget modeCycles() {
    return Container(

      /**
       * cycles is set to slider value
       * time range picker is created with fixed duration = cycles * 90
       * output of time range picker is pushed to text
       */
      child: Column(
        children: [
          Text('Select Number of Sleep Cycles: ${cycles?.toInt() ?? 0}'),
          Slider(
            value: cycles ?? 0,
            min: 0,
            max: maxSleepCycle,
            divisions: maxSleepCycle.toInt(),
            onChanged: (value) {
              setState(() {
                cycles = value;
                fixedWake = null;
                fixedSleep = null;
                _startTime = TimeOfDay.fromDateTime(DateTime.now());
                _endTime = _startTime.replacing(
                    hour: _startTime.hour + (cycles! * cycleLength ~/ 60));
              });
            },
          ),
          if (cycles != null)
            Text(
                'Selected Sleep Time: ${_startTime.format(context)} - ${_endTime
                    .format(context)}')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Calculator'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a mode:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return modeWake();
                  },
                );
              },
              child: Text('Fixed Wake Time'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return modeSleep();
                  },
                );
              },
              child: Text('Fixed Sleep Time'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return modeCycles();
                  },
                );
              },
              child: Text('Number of Sleep Cycles'),
            ),
            SizedBox(height: 16.0),
            if (fixedWake != null)
              Text('Selected Wake Time: ${fixedWake!.hour}:${fixedWake!
                  .minute}'),
            if (fixedSleep != null)
              Text('Selected Sleep Time: ${fixedSleep!.hour}:${fixedSleep!
                  .minute}'),
            if (cycles != null)
              Text('Selected Sleep Time: ${_startTime.format(
                  context)} - ${_endTime.format(context)}'),
          ],
        ),
      ),
    );
  }
}










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
          Row(
            children: [
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
              SizedBox(width: 8),
              DropdownButton<String>(
                value: fixedWake?.period == DayPeriod.am ? 'AM' : 'PM',
                onChanged: (value) {
                  setState(() {
                    final period = value == 'AM' ? DayPeriod.am : DayPeriod.pm;
                    final time = TimeOfDay(hour: fixedWake!.hour, minute: fixedWake!.minute);
                    updateWakeTime(time.replacing(period: period));
                  });
                },
                items: ['AM', 'PM']
                    .map((value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
              ),
            ],
          ),
          if (fixedWake != null) ...[
            Text('Selected Wake Time: ${fixedWake!.format(context)}'),
          ],
          SizedBox(height: 16),
          Text('Select Wakeup time range:'),
          ElevatedButton(
            onPressed: () async {
              final picked = await showTimeRangePicker(
                context: context,
                start: TimeOfDay(hour: 6, minute: 0),
                end: TimeOfDay(hour: 12, minute: 0),
                interval: Duration(minutes: 30),
              );
              if (picked != null) {
                setState(() {
                  updateWakeTime(picked.start);
                });
              }
            },
            child: Text('Select Time Range'),
          ),
        ],
      );
    }

    Widget modeSleep() {
      return Container(

        /**
         * create time picker for fixed sleep; fixed wake and cycles set to null
         * starting point will be set to fixed sleep
         * time range picker outputs to text
         */
        child: Column(
          children: [
            Text('Select Fixed Sleep Time:'),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _endTime,
                );
                if (picked != null) {
                  setState(() {
                    fixedSleep = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      picked.hour,
                      picked.minute,
                    );
                    fixedWake = null;
                    cycles = null;
                    _startTime = picked;
                    bestSleepTime = fixedSleep;
                    bestWakeTime = fixedSleep!.add(Duration(minutes: (cycles! * cycleLength).toInt()));
                  });
                }
              },
              child: Text('Select Time'),
            ),
            if (fixedSleep != null)
              Text('Selected Sleep Time: ${fixedSleep!.hour}:${fixedSleep!.minute}'),
            if (bestWakeTime != null && bestSleepTime != null)
              Column(
                children: [
                  Text('Best time to Wake up: ${bestWakeTime!.hour}:${bestWakeTime!.minute}')
                ],
              )
          ],
        ),
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

// copy and pasted from my main computer










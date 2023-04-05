import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    List<Widget> content = [];

    String labelRangePickerButton = "Select Time Range";

    void updateWakeTime(TimeOfDay time) {
      fixedWake = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      print(fixedWake.toString());
    }

    void updateRangePickerButtonLabel(TimeOfDay input) {
      labelRangePickerButton = input.toString();
    }

    content.add(Text("Select Fixed Wake Time:"));
    content.add(
      ElevatedButton.icon(
        onPressed: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          print("PICK" + picked.toString());
          if (picked != null) {
            setState(() {
              updateWakeTime(picked);
            });
          }
        },
        icon: Icon(Icons.alarm),
        label: Text('Select Time'),
        style: ElevatedButton.styleFrom(
          primary: Colors.purple,
          onPrimary: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
    content.add(
      SizedBox(
        width: 100,
        height: 100,
        child: Text(
          "Selected Wake Time: " + (fixedWake?.toString() ?? ""),
        ),
      ),
    );
    content.add(
      SizedBox(
        width: 100,
        height: 100,
        child: Text(
          "Select Wakeup time range: ",
        ),
      ),
    );
    content.add(
      SizedBox(
        height: 100,
        child: ElevatedButton.icon(
          icon: Icon(Icons.access_time),
          label: Text(labelRangePickerButton),
          onPressed: () async {
            if (fixedWake == null) {
              // Show an error message if fixedWake is not set
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Error"),
                  content: Text("Please select a fixed wake time first."),
                ),
              );
              return;
            }
            final picked = await showTimeRangePicker(
              context: context,
              start: TimeOfDay(hour: fixedWake?.hour ?? TimeOfDay.now().hour, minute: fixedWake?.minute ?? TimeOfDay.now().minute),
              minDuration: Duration(minutes: 90),
              interval: Duration(minutes: 90),
              onStartChange: (time) {
                updateRangePickerButtonLabel(time);
                setState(() {
                  _startTime = _startTime;
                });
              },
              onEndChange: (time) {
                updateRangePickerButtonLabel(time);
                setState(() {
                  _endTime = time;
                });
              },
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            onPrimary: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
    return Column(
      children: content,
    );
  }

  Widget modeSleep() {
    final now = DateTime.now();
    final sleepCycle = 90;
    final maxCycles = 16;
    final cycleLength = Duration(minutes: sleepCycle);
    DateTime? fixedSleep;
    List<Widget> content = [];

    String labelRangePickerButton = "Select Time Range";

    void updateSleepTime(TimeOfDay time) {
      fixedSleep = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      print(fixedSleep.toString());
    }

    void updateRangePickerButtonLabel(TimeOfDay input) {
      labelRangePickerButton = input.toString();
    }

    content.add(Text("Select Fixed Sleep Time:"));
    content.add(ElevatedButton(
      onPressed: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        print("PICK" + picked.toString());
        if (picked != null) {
          setState(() {
            updateSleepTime(picked);
          });
        }
      },
      child: Text('Select Time'),
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey,
        textStyle: TextStyle(fontSize: 20),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ));
    content.add(
      SizedBox(
        width: 300,
        height: 100,
        child: Text(
          "Selected Sleep Time: " + (fixedSleep?.toString() ?? ""),
        ),
      ),
    );
    content.add(
      SizedBox(
        width: 300,
        height: 100,
        child: Text(
          "Select Sleep Time Range: ",
        ),
      ),
    );
    content.add(
      SizedBox(
        height: 100,
        child: ElevatedButton(
          child: Text(
            labelRangePickerButton,
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () async {
            if (fixedSleep == null) {
              // Show an error message if fixedSleep is not set
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Error"),
                  content: Text("Please select a fixed sleep time first."),
                ),
              );
              return;
            }
            final picked = await showTimeRangePicker(
              context: context,
              start: TimeOfDay(hour: fixedSleep?.hour ?? TimeOfDay.now().hour, minute: fixedSleep?.minute ?? TimeOfDay.now().minute),
              minDuration: Duration(minutes: 90),
              interval: Duration(minutes: 90),
              onStartChange: (time) {
                updateRangePickerButtonLabel(time);
                setState(() {
                  _startTime = _startTime;
                });
              },
              onEndChange: (time) {
                updateRangePickerButtonLabel(time);
                setState(() {
                  _endTime = time;
                });
              },
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey,
            textStyle: TextStyle(fontSize: 20),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
      ),
    );

    return Container(
      child: Column(
        children: content,
      ),
    );
  }
  Widget modeCycles() {
    final sleepCycle = 90;
    final maxCycles = 16;
    List<Widget> content = [];

    int selectedCycles = 1;
    double minRange = 0;
    double maxRange = (selectedCycles * 6) * sleepCycle.toDouble();

    content.add(Text("Select Number of Sleep Cycles:"));

    content.add(Slider(
      value: selectedCycles.toDouble(),
      min: 1,
      max: maxCycles.toDouble(),
      divisions: maxCycles - 1,
      label: selectedCycles.toString(),
      onChanged: (double value) {
        setState(() {
          selectedCycles = value.toInt();
          maxRange = (selectedCycles * 6) * sleepCycle.toDouble();
        });
      },
    ));

    content.add(
      SizedBox(
        width: 100,
        height: 100,
        child: Text(
          "Selected Cycles: " + selectedCycles.toString(),
        ),
      ),
    );

    content.add(
      SizedBox(
        width: 100,
        height: 100,
        child: Text(
          "Select Sleep time range: ",
        ),
      ),
    );

    content.add(
      SizedBox(
        height: 100,
        child: RangeSlider(
          values: RangeValues(minRange, maxRange),
          min: 0,
          max: (maxCycles * 6) * sleepCycle.toDouble(),
          onChanged: (RangeValues values) {
            setState(() {
              minRange = values.start;
              maxRange = values.end;
            });
          },
        ),
      ),
    );

    return Column(
      children: content,
    );
  }
  /**


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
   */
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
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return modeSleep();
                  }
                );
              },
              child: Text('Fixed Sleep Time'),
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return modeCycles();
                    }
                );
              },
              child: Text('Sleep Cycles'),
            ),
            SizedBox(height: 8.0),
            /**
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
             */
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












import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:time_range_picker/time_range_picker.dart';


class CalcWakeWidget {
  BuildContext? context;
  bool needsUpdating = true; // this is the variable that is actually important. make sure it starts true!

  DateTime now = DateTime.now();
  DateTime fixedWake = DateTime.now();
  String labelRangePickerButton = "";
  TimeOfDay pickerStart = TimeOfDay.now();
  TimeOfDay pickerEnd = TimeOfDay.now();

  CalcWakeWidget(BuildContext ctx) {
    context = ctx;
  }

  void updateWakeTime(TimeOfDay time) {
    fixedWake = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    print(fixedWake.toString());
    needsUpdating = true;
  }

  void updateRangePickerButtonLabel(TimeOfDay input) {
    needsUpdating = true;
    labelRangePickerButton = input.toString();
  }

  Widget toWidget() {
    return Padding(padding: EdgeInsets.all(5),
      child: Container(
        height: 200,
        width: 400,
        color: Colors.amber,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Select Fixed Wake Time:"),
              ElevatedButton.icon(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context!,
                    initialTime: TimeOfDay.now(),
                  );
                  print("PICK" + picked.toString());
                  if (picked != null) {
                    updateWakeTime(picked);
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
              Text(
                "Selected Wake Time: " + (fixedWake?.toString() ?? ""),
              ),
              Text(
                "Select Wakeup time range: ",
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.access_time),
                label: Text(labelRangePickerButton),
                onPressed: () async {
                  if (fixedWake == null) {
                    // Show an error message if fixedWake is not set
                    showDialog(
                      context: context!,
                      builder: (context) =>
                          AlertDialog(
                            title: Text("Error"),
                            content: Text(
                                "Please select a fixed wake time first."),
                          ),
                    );
                    return;
                  }
                  final picked = await showTimeRangePicker(
                    context: context!,
                    start: TimeOfDay(hour: fixedWake?.hour ?? TimeOfDay
                        .now()
                        .hour, minute: fixedWake?.minute ?? TimeOfDay
                        .now()
                        .minute),
                    minDuration: Duration(minutes: 90),
                    interval: Duration(minutes: 90),
                    onStartChange: (time) {
                      updateRangePickerButtonLabel(time);
                      pickerStart = pickerStart;
                      needsUpdating = true;
                    },
                    onEndChange: (time) {
                      updateRangePickerButtonLabel(time);
                      pickerEnd = time;
                      needsUpdating = true;
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
            ]
        ),
      ),
    );
  }
}

class CalcSleepWidget {
  BuildContext? context;
  bool needsUpdating = true; // this is the variable that is actually important. make sure it starts true!

  DateTime now = DateTime.now();
  DateTime fixedSleep = DateTime.now();
  String labelRangePickerButton = "";
  TimeOfDay pickerStart = TimeOfDay.now();
  TimeOfDay pickerEnd = TimeOfDay.now();

  CalcSleepWidget(BuildContext ctx) {
    context = ctx;
  }

  void updateSleepTime(TimeOfDay time) {
    fixedSleep = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    print(fixedSleep.toString());
    needsUpdating = true;
  }

  void updateRangePickerButtonLabel(TimeOfDay input) {
    needsUpdating = true;
    labelRangePickerButton = input.toString();
  }

  Widget toWidget() {
    return Padding(padding: EdgeInsets.all(5),
      child: Container(
        height: 200,
        width: 400,
        color: Colors.amber,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Select Fixed Sleep Time:"),
              ElevatedButton.icon(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context!,
                    initialTime: TimeOfDay.now(),
                  );
                  print("PICK" + picked.toString());
                  if (picked != null) {
                    updateSleepTime(picked);
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
              Text(
                "Selected Wake Time: " + (fixedSleep?.toString() ?? ""),
              ),
              Text(
                "Select Sleep time range: ",
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.access_time),
                label: Text(labelRangePickerButton),
                onPressed: () async {
                  if (fixedSleep == null) {
                    // Show an error message if fixedWake is not set
                    showDialog(
                      context: context!,
                      builder: (context) =>
                          AlertDialog(
                            title: Text("Error"),
                            content: Text(
                                "Please select a fixed wake time first."),
                          ),
                    );
                    return;
                  }
                  final picked = await showTimeRangePicker(
                    context: context!,
                    start: TimeOfDay(hour: fixedSleep?.hour ?? TimeOfDay
                        .now()
                        .hour, minute: fixedSleep?.minute ?? TimeOfDay
                        .now()
                        .minute),
                    minDuration: Duration(minutes: 90),
                    interval: Duration(minutes: 90),
                    onStartChange: (time) {
                      updateRangePickerButtonLabel(time);
                      pickerStart = pickerStart;
                      needsUpdating = true;
                    },
                    onEndChange: (time) {
                      updateRangePickerButtonLabel(time);
                      pickerEnd = time;
                      needsUpdating = true;
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
            ]
        ),
      ),
    );
  }
}


class CycleWidget {

  final sleepCycle = 90;
  final maxCycles = 16;
  BuildContext? context;
  List<Widget> content = [];
  bool needsUpdating = true;
  int selectedCycles = 1;
  double minRange = 0;
  double maxRange = 0;

  CycleWidget(BuildContext ctx) {
    context = ctx;
    maxRange = (selectedCycles * 6) * sleepCycle.toDouble();
  }

  Widget toWidget() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        height: 400,
        width: 400,
        color: Colors.amber,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Slider(
              value: selectedCycles.toDouble(),
              min: 1,
              max: maxCycles.toDouble(),
              divisions: maxCycles - 1,
              label: selectedCycles.toString(),
              onChanged: (double value) {
                needsUpdating = true;
                selectedCycles = value.toInt();
                maxRange = (selectedCycles * 6) * sleepCycle.toDouble();
              },
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Text(
                "Selected Cycles: " + selectedCycles.toString(),
              ),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Text(
                "Select Sleep time range: ",
              ),
            ),
            SizedBox(
              height: 100,
              child: RangeSlider(
                values: RangeValues(minRange, maxRange),
                min: 0,
                max: (maxCycles * 6) * sleepCycle.toDouble(),
                onChanged: (RangeValues values) {
                  needsUpdating = true;
                  minRange = values.start;
                  maxRange = values.end;
                  selectedCycles =
                      (maxRange / (6 * sleepCycle.toDouble())).ceil();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}















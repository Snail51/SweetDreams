
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:tuple/tuple.dart';

//hi
class CalcWakeWidget {
  BuildContext context;
  VoidCallback updateCallback;
  DateTime now = DateTime.now();
  String labelRangePickerButton = "";
  TimeOfDay pickerStart = TimeOfDay.now();
  int selectedCycles = 1;
  bool needsUpdating = true;
  bool isTimeAndCyclesSelected = false;

  CalcWakeWidget(this.context, {required this.updateCallback});

  DateTime getNearestWakeTime(int numCycles, TimeOfDay sleepTime) {
    int minutes = numCycles * 90;
    DateTime currentTime =
    DateTime(now.year, now.month, now.day, sleepTime.hour, sleepTime.minute);
    DateTime targetTime = currentTime.add(Duration(minutes: minutes));
    return targetTime;
  }

  Widget toWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 300,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "Sleep Cycles:",
              style: TextStyle(fontSize: 20.0),
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.deepPurple,
                inactiveTrackColor: Colors.grey,
                thumbColor: Colors.deepPurple,
                overlayColor: Colors.deepPurple.withOpacity(0.2),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                trackHeight: 4.0,
                valueIndicatorColor: Colors.deepPurple,
                valueIndicatorTextStyle: TextStyle(color: Colors.white),
              ),
              child: Column(
                children: <Widget>[
                  Slider(
                    value: selectedCycles.toDouble(),
                    min: 1,
                    max: 16,
                    divisions: 15,
                    label: selectedCycles.toString(),
                    onChanged: (double value) {
                      selectedCycles = value.round();
                      needsUpdating = true;
                      updateCallback();
                    },
                  ),
                  Text(
                    "Chosen Cycles: $selectedCycles",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Text(
              "Select Sleep Time:",
              style: TextStyle(fontSize: 20.0),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  pickerStart = picked;
                  labelRangePickerButton =
                  "${pickerStart.format(context)}";
                  needsUpdating = true;
                  isTimeAndCyclesSelected = true;
                  updateCallback();
                }
              },
              icon: Icon(Icons.alarm),
              label: Text(labelRangePickerButton.isNotEmpty
                  ? labelRangePickerButton
                  : 'Select Time'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Text(
              "You should wake up at:",
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            Text(
              !isTimeAndCyclesSelected
                  ? ""
                  : DateFormat.jm().format(
                  getNearestWakeTime(selectedCycles, pickerStart)),
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


class CalcSleepWidget {
  BuildContext context;
  VoidCallback updateCallback;
  DateTime now = DateTime.now();
  TimeOfDay pickerStart = TimeOfDay(hour: 7, minute: 0);
  int selectedCycles = 1;
  bool needsUpdating = true;
  bool isTimeAndCyclesSelected = false;

  CalcSleepWidget(this.context, {required this.updateCallback});

  DateTime getNearestSleepTime(int numCycles, TimeOfDay wakeTime) {
    int minutes = numCycles * 90;
    DateTime currentTime =
    DateTime(now.year, now.month, now.day, wakeTime.hour, wakeTime.minute);
    DateTime targetTime = currentTime.subtract(Duration(minutes: minutes));
    return targetTime;
  }

  Widget toWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 300,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: [
                Text(
                  "Sleep Cycles:",
                  style: TextStyle(fontSize: 20.0),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.deepPurple,
                    inactiveTrackColor: Colors.grey,
                    thumbColor: Colors.deepPurple,
                    overlayColor: Colors.deepPurple.withOpacity(0.2),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                    trackHeight: 4.0,
                    valueIndicatorColor: Colors.deepPurple,
                    valueIndicatorTextStyle: TextStyle(color: Colors.white),
                  ),
                  child: Column(
                    children: <Widget>[
                      Slider(
                        value: selectedCycles.toDouble(),
                        min: 1,
                        max: 16,
                        divisions: 15,
                        label: selectedCycles.toString(),
                        onChanged: (double value) {
                          selectedCycles = value.round();
                          needsUpdating = true;
                          updateCallback();
                        },
                      ),
                      Text(
                        "Chosen Cycles: $selectedCycles",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "Select Wake Time:",
              style: TextStyle(fontSize: 20.0),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: pickerStart,
                );
                if (picked != null) {
                  pickerStart = picked;
                  needsUpdating = true;
                  isTimeAndCyclesSelected = true;
                  updateCallback();
                }
              },
              icon: Icon(Icons.alarm),
              label: Text(isTimeAndCyclesSelected ? pickerStart.format(context) : 'Select Time'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "You should go to sleep at:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            Text(
              !isTimeAndCyclesSelected
                  ? ""
                  : DateFormat('h:mm a').format(
                  getNearestSleepTime(selectedCycles, pickerStart)),
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}





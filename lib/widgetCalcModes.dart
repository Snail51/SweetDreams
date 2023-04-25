
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
        height: 250,
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
              "Select number of sleep cycles:",
              style: TextStyle(fontSize: 20.0),
            ),
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
                  needsUpdating = true;
                  isTimeAndCyclesSelected = true;
                  updateCallback();
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
              !isTimeAndCyclesSelected
                  ? ""
                  : "Selected Sleep Time: " +
                  DateFormat('h:mm a').format(DateTime(now.year, now.month, now.day, pickerStart.hour, pickerStart.minute)),
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nearest estimated wake up time:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            Text(
              !isTimeAndCyclesSelected
                  ? ""
                  : DateFormat('h:mm a').format(
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
        height: 250,
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
              "Select number of sleep cycles:",
              style: TextStyle(fontSize: 20.0),
            ),
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
            SizedBox(height: 10),
            Text(
              !isTimeAndCyclesSelected
                  ? ""
                  : "Selected Wake Time: " +
                  DateFormat('h:mm a').format(DateTime(now.year, now.month, now.day, pickerStart.hour, pickerStart.minute)),
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nearest estimated sleep time:",
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
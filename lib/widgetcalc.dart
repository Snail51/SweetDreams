import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:units/database.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'dart:ui';



class widgetModeWake {
  final DateTime now = DateTime.now();
  final int sleepCycle = 90;
  final int maxCycles = 16;
  final Duration cycleLength = Duration(minutes: 90);
  DateTime? fixedWake;
  List<Widget> content = [];

  bool needsUpdating = true;
  TimeOfDay start = TimeOfDay.now();
  TimeOfDay end = TimeOfDay.now();
  BuildContext? context;

  widgetModeWake(String name, BuildContext con) {
    name = name;
    context = con;
  }

  String labelRangePickerButton = "Select Time Range";

  Widget toWidget() {

    content.add(Text("Select Fixed Wake Time:"));
    content.add(
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
                context: context!,
                builder: (context) =>
                    AlertDialog(
                      title: Text("Error"),
                      content: Text("Please select a fixed wake time first."),
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
                start = start;
              },
              onEndChange: (time) {
                updateRangePickerButtonLabel(time);
                end = time;
                needsUpdating = true;
                print(end);
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

  void updateWakeTime(TimeOfDay time) {
    needsUpdating = true;
    fixedWake =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    print(fixedWake.toString());
  }

  void updateRangePickerButtonLabel(TimeOfDay input) {
    needsUpdating = true;
    labelRangePickerButton = input.toString();
  }

}





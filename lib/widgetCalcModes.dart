import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:time_range_picker/time_range_picker.dart';


class CalcSleepWidgit // CONTENT CLASS THAT HAS NO ACCESS TO setState() BECAUSE IT IS OUTSIDE OF A STATEFUL CLASS
    {
  BuildContext? context;
  List<Widget> content = [];
  bool needsUpdating = true; // this is the variable that is actually important. make sure it starts true!

  DateTime now = DateTime.now();
  DateTime fixedWake = DateTime.now();
  String labelRangePickerButton = "";
  TimeOfDay pickerStart = TimeOfDay.now();
  TimeOfDay pickerEnd = TimeOfDay.now();




  CalcSleepWidgit(BuildContext ctx)
  {
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
    content = [];
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
      ),
    );
    return Column(
      children: content,
    );
  }



}

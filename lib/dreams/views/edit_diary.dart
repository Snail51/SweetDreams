import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/diary.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditDiaryPage extends StatefulWidget {

  EditDiaryPage({Key? key, required this.diary, required this.entry}) : super (key: key);
  Diary diary;
  DiaryEntry entry;

  @override
  _EditDiaryPageState createState() => _EditDiaryPageState();
}

class _EditDiaryPageState extends State<EditDiaryPage> {
  @override
  void initState() {
    super.initState();
    title.text = widget.entry.title;
    textField.text = widget.entry.content;
    labelSelectDate =
        widget.entry.timeRef.month.toString() + "/" + widget.entry.timeRef.day.toString() +
            "/" + widget.entry.timeRef.year.toString();
    String temp3 = "";
    String temp4 = "";
    TimeOfDay tempTime = new TimeOfDay(hour: widget.entry.timeRef.hour, minute: widget.entry.timeRef.minute);
    if (tempTime.period == DayPeriod.am) temp3 = " am";
    if (tempTime.period == DayPeriod.pm) temp3 = " pm";
    temp4 = tempTime.hourOfPeriod.toString();
    labelSelectTime = temp4 + ":" + tempTime.minute.toString() + temp3;
  }

  var title = TextEditingController();
  var textField = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String labelSelectDate = "Select a Date";
  String labelSelectTime = "Enter Your Sleep Time";

  bool check1 = false;
  bool check2 = false;

  @override
  Widget build(BuildContext context) {

    _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                onSurface: Colors.deepPurple.shade300,
              ),
              dialogBackgroundColor: Colors.grey.shade900,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.deepPurple, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
      labelSelectDate =
          selectedDate.month.toString() + "/" + selectedDate.day.toString() +
              "/" + selectedDate.year.toString();
    }

    _selectTime(BuildContext context) async {
      var time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now());

      if (time != null) {
        setState(() {
          selectedTime = TimeOfDay(hour: time.hour, minute: time.minute);
          String temp1 = "";
          String temp2 = "";
          if(time.period == DayPeriod.am) temp1 = " am";
          if(time.period == DayPeriod.pm) temp1 = " pm";
          temp2 = time.hourOfPeriod.toString();
          labelSelectTime = temp2 + ":" + time.minute.toString() + temp1;
        });
      }
    }

    _editDiary(DateTime selectedDate, TimeOfDay selectedTime, var title, var textField) async {

      DateTime tempDate = DateTime.now();
      TimeOfDay tempTime = TimeOfDay.now();

      if (check1 == false) tempDate = widget.entry.timeRef;
      else if (check1 == true) tempDate = selectedDate;
      if (check2 == false) tempTime = new TimeOfDay(hour: widget.entry.timeRef.hour, minute: widget.entry.timeRef.minute);
      else if (check2 == true) tempTime = selectedTime;

      DateTime tempTime2 = new DateTime(tempDate.year, tempDate.month, tempDate.day, tempTime.hour, tempTime.minute);
      widget.diary.editEvent(widget.entry.eventNumber, Ref: tempTime2, Title: title.text, Content: textField.text);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Diary"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
          child: Column(
            children: <Widget>[

              Padding(
                  padding: EdgeInsets.only(top: 20.0,),
                  child: Text("Edit Diary", style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    textScaleFactor: 3,)
              ),

              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple
                    ),
                    child: Text(labelSelectDate),
                    onPressed: () {
                      _selectDate(context);
                      check1 = true;
                    }
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple
                    ),
                    child: Text(labelSelectTime),
                    onPressed: () {
                      _selectTime(context);
                      check2 = true;
                    }
                ),
              ),

              Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 110.0, right: 110.0,),
                  child: TextField(
                    maxLength: 20,
                    decoration: InputDecoration(
                        counterStyle: new TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple)),
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                        labelStyle: new TextStyle(color: Colors.deepPurple)
                    ),
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: title,
                  )
              ),

              Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                  child: TextField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple)),
                        border: OutlineInputBorder(),
                        labelText: 'Write in Your Sleep Diary',
                        labelStyle: new TextStyle(color: Colors.deepPurple)
                    ),
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: textField,
                  )
              ),

              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple
                    ),
                    child: Text('Done'),
                    onPressed: () =>
                        _editDiary(selectedDate, selectedTime, title, textField)
                ),
              ),

            ],
          )
      ),
    );
  }
}
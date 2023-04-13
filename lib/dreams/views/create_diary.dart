import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import 'package:time_range_picker/time_range_picker.dart';

class CreateDiaryPage extends StatefulWidget {

  CreateDiaryPage({Key? key, required this.database, required this.fileLocation}) : super (key: key);
  SleepData database;
  String fileLocation = "";

  @override
  _CreateDiaryPageState createState() => _CreateDiaryPageState();
}

class _CreateDiaryPageState extends State<CreateDiaryPage> {
  @override
  void initState() {
    super.initState();
  }

  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  var myController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String labelSelectDate = "Select a Date";
  String labelSelectTime = "Enter Your Sleep Time";
  String labelError = "";

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

    _createDiary(DateTime selectedDate, var myController) async {
      if ((check1 != false) && (check2 != false) && (check3 != false)) {
        Navigator.pop(context);
      }

      else  {
        setState(() {
          labelError = "Error: Not all Entries are Filled";
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("New Diary"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
          child: Column(
            children: <Widget>[

              Padding(
                  padding: EdgeInsets.only(top: 20.0,),
                  child: Text("New Diary", style: const TextStyle(
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
                    controller: myController,
                    onTap: () {
                      check3 = true;
                    },
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
                        _createDiary(selectedDate, myController)
                ),
              ),

              Padding(
                  padding: EdgeInsets.only(top: 20.0,),
                  child: Text(labelError, style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                    textScaleFactor: 2,
                    textAlign: TextAlign.center,)
              ),

            ],
          )
      ),
    );
  }
}

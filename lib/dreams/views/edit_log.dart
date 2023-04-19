import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:units/database.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditLogPage extends StatefulWidget {

  EditLogPage({Key? key, required this.database, required this.log}) : super (key: key);
  SleepData database;
  SleepEvent log;

  @override
  _EditLogPageState createState() => _EditLogPageState();
}

class _EditLogPageState extends State<EditLogPage>  {
  @override
  void initState() {
    super.initState();
  }

  double rating = 0;
  var myController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeRange selectedTime = TimeRange(startTime: TimeOfDay.now(), endTime: TimeOfDay.now());

  String labelSelectDate = "Select a Date";
  String labelSelectTimeRange = "Enter Your Sleep Time";

  bool check1 = false;
  bool check2 = false;
  bool check3 = false;

  @override
  Widget build(BuildContext context) {

     _initialSetup() {
      myController.text = widget.log.dream;
      labelSelectDate =
          widget.log.sleep.month.toString() + "/" + widget.log.sleep.day.toString() +
              "/" + widget.log.sleep.year.toString();
      String temp1 = "";
      String temp2 = "";
      String temp3 = "";
      String temp4 = "";
      TimeOfDay sleepTemp = new TimeOfDay(hour: widget.log.sleep.hour, minute: widget.log.sleep.minute);
      TimeOfDay wakeTemp = new TimeOfDay(hour: widget.log.wake.hour, minute: widget.log.wake.minute);
      if (sleepTemp.period == DayPeriod.am) temp1 = " am";
      if (sleepTemp.period == DayPeriod.pm) temp1 = " pm";
      temp2 = sleepTemp.hourOfPeriod.toString();
      if (wakeTemp.period == DayPeriod.am) temp3 = " am";
      if (wakeTemp.period == DayPeriod.pm) temp3 = " pm";
      temp4 = wakeTemp.hourOfPeriod.toString();
      labelSelectTimeRange =
          temp2 + ":" + sleepTemp.minute.toString() + temp1 +
              " - " + temp4 + ":" + wakeTemp.minute.toString() +
              temp3;
    }

    _selectDate(BuildContext context) async{
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate, // Refer step 1
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

      labelSelectDate = selectedDate.month.toString() + "/" + selectedDate.day.toString() + "/" + selectedDate.year.toString();


    }

    _selectTimeRange(BuildContext context) async{
      final TimeRange? picked = await showTimeRangePicker(
          context: context,
          strokeColor: Colors.deepPurple,
          handlerColor: Colors.deepPurple,
          selectedColor: Colors.deepPurple.shade200,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.deepPurple,
                ),
                dialogBackgroundColor: Colors.grey.shade900,
                primaryColor: Colors.deepPurple,
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
      if (picked != null)
      {
        setState(() {
          selectedTime = picked;
          String temp1 = "";
          String temp2 = "";
          String temp3 = "";
          String temp4 = "";
          if(selectedTime.startTime.period == DayPeriod.am) temp1 = " am";
          if(selectedTime.startTime.period == DayPeriod.pm) temp1 = " pm";
          temp2 = selectedTime.startTime.hourOfPeriod.toString();
          if(selectedTime.endTime.period == DayPeriod.am) temp3 = " am";
          if(selectedTime.endTime.period == DayPeriod.pm) temp3 = " pm";
          temp4 = selectedTime.endTime.hourOfPeriod.toString();
          labelSelectTimeRange = temp2 + ":" + selectedTime.startTime.minute.toString() + temp1 + " - " + temp2 + ":" + selectedTime.startTime.minute.toString() + temp1;
        });
      }
    }

    _editLog(DateTime selectedDate, TimeRange selectedTime, double rating, var myController) async  {

       DateTime sleep = DateTime.now();
       DateTime wake = DateTime.now();
       double tempRate = 0.0;

       if (check1 == true && check2 == true) {
         sleep = DateTime(
             selectedDate.year, selectedDate.month, selectedDate.day,
             selectedTime.startTime.hour, selectedTime.startTime.minute);
         wake = DateTime(
             selectedDate.year, selectedDate.month, selectedDate.day,
             selectedTime.endTime.hour, selectedTime.endTime.minute);
       }
       else if (check1 == false && check2 == false)  {
         sleep = widget.log.sleep;
         wake = widget.log.wake;
       }
       else if (check1 == true && check2 == false)  {
         sleep = DateTime(
             selectedDate.year, selectedDate.month, selectedDate.day,
             widget.log.sleep.hour, widget.log.sleep.minute);
         wake = DateTime(
             selectedDate.year, selectedDate.month, selectedDate.day,
             widget.log.wake.hour, widget.log.wake.minute);
       }
       else if (check1 == false && check2 == true)  {
         sleep = DateTime(
             widget.log.sleep.year, widget.log.sleep.month, widget.log.sleep.day,
             selectedTime.startTime.hour, selectedTime.startTime.minute);
         wake = DateTime(
             widget.log.wake.year, widget.log.wake.month, widget.log.wake.day,
             selectedTime.endTime.hour, selectedTime.endTime.minute);
       }

       if (check3 == false) tempRate = widget.log.quality.toDouble();
       else if (check3 == true) tempRate = rating;
        widget.database.editEvent(widget.log.eventNumber, Start: sleep,
            End: wake,
            Quality: tempRate.toInt(),
            Dream: myController.text);
        widget.database.save();
        Navigator.pop(context);
    }

    _initialSetup();
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Log"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20.0,),
                  child: Text("Edit Log", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple), textScaleFactor: 3,)
              ),

              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
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
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple
                    ),
                    child: Text(labelSelectTimeRange),
                    onPressed: () {
                      _selectTimeRange(context);
                      check2 = true;
                    }
                ),
              ),

              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: RatingBar(
                  minRating: 0,
                  maxRating: 5,
                  initialRating: 3,
                  allowHalfRating: false,
                  onRatingUpdate: (rate)  {
                    setState(() {
                      rating = rate;
                      check3 = true;
                    });
                  },
                  ratingWidget: RatingWidget(
                      full: Icon(
                        Icons.star,
                        color: Colors.deepPurple,
                      ),
                      half: Image.asset("star_half.png", color: Colors.deepPurple),
                      empty: Icon(
                        Icons.star,
                        color: Colors.grey,
                      )
                  ),
                ),
              ),

              Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                  child: TextField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                        border: OutlineInputBorder(),
                        labelText: 'Write about your dreams/nightmares',
                        labelStyle: new TextStyle(color: Colors.deepPurple)
                    ),
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: myController,
                  )
              ),

              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple
                    ),
                    child: Text('Done'),
                    onPressed: () => _editLog(selectedDate, selectedTime, rating, myController)
                ),
              ),

              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple
                    ),
                    child: Text('Delete Log'),
                    onPressed: () {
                      widget.database.delEvent(widget.log.eventNumber);
                      Navigator.pop(context);
                    }
                ),
              ),

            ],
          )
      ),
    );
  }
}
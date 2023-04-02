import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:units/database.dart';
import 'package:time_range_picker/time_range_picker.dart';

class CreateLogPage extends StatefulWidget {

  CreateLogPage({Key? key, required this.database}) : super (key: key);
  SleepData database;

  @override
  _CreateLogPageState createState() => _CreateLogPageState();
}

class _CreateLogPageState extends State<CreateLogPage>  {
  @override
  void initState() {
    super.initState();
  }

  double rating = 0;
  var myController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeRange selectedTime = TimeRange(startTime: TimeOfDay.now(), endTime: TimeOfDay.now());



  @override
  Widget build(BuildContext context) {

    _selectDate(BuildContext context) async{
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate, // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

    _createLog(DateTime selectedDate, TimeRange selectedTime, double rating, var myController) async  {
      String tempString = myController.text;
      DateTime sleep = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.startTime.hour, selectedTime.startTime.minute);
      DateTime wake = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.endTime.hour, selectedTime.endTime.minute);
      widget.database.addEvent(sleep, wake: wake, quality: rating.toInt(), dream: myController.text);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("New Log"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20.0,),
                  child: Text("New Log", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent), textScaleFactor: 3,)
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent
                    ),
                    child: Text('Select a Date'),
                    onPressed: () => _selectDate(context)
                ),
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent
                    ),
                    child: Text('Enter Your Sleep Time'),
                    onPressed: () async  {
                      selectedTime = await showTimeRangePicker(context: context);
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
                    });
                  },
                  ratingWidget: RatingWidget(
                      full: Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      half: Image.asset("star_half.png", color: Colors.yellow),
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
                        border: OutlineInputBorder(),
                        labelText: 'Write about your dreams/nightmares'
                    ),
                    controller: myController,
                  )
              ),
              Padding(
                padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0,),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent
                    ),
                    child: Text('Done'),
                    onPressed: () => _createLog(selectedDate, selectedTime, rating, myController)
                ),
              ),
            ],
          )
      ),
    );
  }
}
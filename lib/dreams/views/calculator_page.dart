/**

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/dreams_constant.dart';
import 'package:units/database.dart';

class HomePage extends StatefulWidget {

  HomePage({Key? key, required this.database}) : super (key: key);

  SleepData database;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {

  var _sleepHourController = TextEditingController();
  var _sleepMinuteController = TextEditingController();
  var _hourController = TextEditingController();
  var _minuteController = TextEditingController();
  var _cycleController = TextEditingController();
  String _hour = "0.0";
  String _minute = "0.0";
  String _sleepMinute = "0.0";
  String _sleepHour = "0.0";
  String _cycle = "0.0";
  var _resultString = '';
  var _timeString = '';
  var _message = '';
  var _value = 0;
  var _valueTime = 0;
  UnitType _unitType = UnitType.WAKE;
  UnitType _unitTypeTime = UnitType.AM;
  final FocusNode _hourFocus = FocusNode();
  final FocusNode _sleepHourFocus = FocusNode();
  final FocusNode _sleepMinuteFocus = FocusNode();
  final FocusNode _minuteFocus = FocusNode();
  final FocusNode _cycleFocus = FocusNode();

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void handleRadioValueChanged(int? value) {
    //this.widget.presenter.onOptionChanged(value!, sleepHourString: _sleepHour, sleepMinuteString: _sleepMinute, sleepCycle: _cycle);
    onOptionChanged(value!, sleepHourString: _sleepHour, sleepMinuteString: _sleepMinute, sleepCycle: _cycle);
  }
  void handleRadioValueChangedTime(int? value) {
    //this.widget.presenter.onTimeOptionChanged(value!);
    onTimeOptionChanged(value!);
  }

  void _calculator() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //this.widget.presenter.onCalculateClicked(_hour, _minute, _sleepMinute, _sleepHour, _cycle);
      onCalculateClicked(_hour, _minute, _sleepMinute, _sleepHour, _cycle);
    }
  }

  void onOptionChanged(int value, {required String sleepMinuteString, required String sleepHourString, required String sleepCycle})  {
    if (value != _valueTime) value = _valueTime;
    var curOdom = 0.0;
    var fuelUsed = 0.0;
    var cycle = 0.0;
    if (sleepHourString.isNotEmpty) {
      try {
        curOdom = double.parse(sleepHourString);
      } catch (e) {
      }
    }
    if (sleepMinuteString.isNotEmpty) {
      try {
        fuelUsed = double.parse(sleepMinuteString);
      } catch (e) {

      }
    }
    if (sleepCycle.isNotEmpty) {
      try {
        cycle = double.parse(sleepCycle);
      } catch (e) {

      }
    }
  }

  void onTimeOptionChanged(int value)  {
    if (value != _valueTime)  {
      _valueTime = value;
    }
  }

  void onCalculateClicked(String hourString, String minuteString, String sleepMinuteString, String sleepHourString, String cycleString) {
    var hour = 0.0;
    var minute = 0.0;
    var sleepHour = 0.0;
    var sleepMinute = 0.0;
    var cycle = 0.0;
    try {
      hour = double.parse(hourString);
    } catch (e){

    }
    try {
      minute = double.parse(minuteString);
    } catch (e){

    }
    try {
      sleepHour = double.parse(sleepHourString);
    } catch (e){

    }
    try {
      sleepMinute = double.parse(sleepMinuteString);
    } catch (e) {

    }
    try {
      cycle = double.parse(cycleString);
    } catch (e) {

    }

    List temp = new List.filled(3, null, growable: false);
    _hour = hour.toString();
    _minute = minute.toString();
    _sleepHour = sleepHour.toString();
    _sleepMinute = sleepMinute.toString();
    _cycle = cycle.toString();
    temp = calculator(hour,minute,sleepHour, sleepMinute, _unitType, _unitTypeTime, cycle);
  }

  List<dynamic> calculator(double hour, double minute, double sleepHour, double sleepMinute, UnitType uniType, UnitType unitTypeTime, double cycle) {

    List result = new List.filled(3, null, growable: false);
    double tempHour = 0.0;
    double tempMinute = 0.00;
    double cycle = 90.00;

    if(uniType == UnitType.BED) {
      tempHour = hour + sleepHour;
      tempMinute = minute + sleepMinute;

      if (tempMinute >= 60) {
        tempMinute -= 60;
        tempHour += 1;
      }
    }
    if (uniType == UnitType.WAKE) {
      tempHour = hour - sleepHour;
      tempMinute = minute - sleepMinute;

      if(tempMinute < 0){
        tempMinute += 60.00;
        tempHour -= 1;
      }
    }

    if(tempHour > 12 || tempHour < 0) {
      switch(unitTypeTime) {
        case UnitType.AM: { unitTypeTime = UnitType.PM; }
        break;
        case UnitType.PM: { unitTypeTime = UnitType.AM; }
        break;
        default: {}
        break;
      }

      tempHour %= 12;
    }
    if(tempHour ==0){
      tempHour = 12;
    }

    //result = tempHour + (tempMinute/300);
    result[0] = (tempHour + (tempMinute/300)); // mess with this
    result[1] = unitTypeTime;
    result[2] = uniType;
    return result;
  }

  void updateResultValue(String resultValue){
    setState(() {
      _resultString = resultValue;
    });
  }

  void updateTimeString(String timeString){
    setState(() {
      _timeString = timeString;
    });
  }

  void updateMessage(String message){
    setState(() {
      _message = message;
    });
  }

  void updateSleepMinute({required String sleepMinute}){
    setState(() {
      // ignore: unnecessary_null_comparison
      _sleepMinuteController.text = sleepMinute != null?sleepMinute:'';
    });
  }

  void updateSleepHour({required String sleepHour}){
    setState(() {
      // ignore: unnecessary_null_comparison
      _sleepHourController.text = sleepHour != null?sleepHour:'';
    });
  }

  void updateHour({required String hour}) {
    setState(() {
      _hourController.text = hour != null ? hour : '';
    });
  }

  void updateMinute({required String minute}) {
    setState(() {
      _minuteController.text = minute != null ? minute : '';
    });
  }

  void updateUnit(int value){
    setState(() {
      _value = value;
    });
  }

  void updateTimeUnit(int value){
    setState(() {
      _valueTime = value;
    });
  }

  void updateCycle({required String cycle}) {
    setState(() {
      _cycleController.text = cycle != null ? cycle : '';
    });
  }

  @override
  Widget build(BuildContext context)  {

    var _unitView = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio<int>(
          activeColor: Colors.black,
          value: 0, groupValue: _value, onChanged: handleRadioValueChanged,
        ),
        Text(
          'Wake up at',
          style: TextStyle(color: Colors.black),
        ),
        Radio<int>(
          activeColor: Colors.black,
          value: 1, groupValue: _value, onChanged: handleRadioValueChanged,
        ),
        Text(
          'Go to bed at',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );

    var _unitViewTime = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio<int>(
          activeColor: Colors.black,
          value: 0, groupValue: _valueTime, onChanged: handleRadioValueChangedTime,
        ),
        Text(
          'AM',
          style: TextStyle(color: Colors.black),
        ),
        Radio<int>(
          activeColor: Colors.black,
          value: 1, groupValue: _valueTime, onChanged: handleRadioValueChangedTime,
        ),
        Text(
          'PM',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );

    var _mainPartView = Opacity(
      opacity: 0.8,
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text("I want to:",style: const TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.5,)
                  ,),
                _unitView,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: hourFormField(context),
                    ),
                    Expanded(
                      child: minFormField(context),
                    )
                  ],
                ),
                _unitViewTime,
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text("I want to sleep for:",style: const TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.5,)
                  ,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: sleepHourFormField(context),
                    ),
                    Expanded(
                      child: sleepMinuteFormField(),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text("How many sleep cycles?",style: const TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.5)
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: cycleFormField(context),
                    )
                  ]
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: calculateButton()
                  ,),
              ],
            ),
          ),
        ),
      ),
    );

    var _resultView = Column(
      children: <Widget>[
        Center(
          child: Text(
            '$_message $_resultString $_timeString',
            style: TextStyle(
                color: Colors.teal,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic
            ),
          ),
        ),
      ],
    );


    return Scaffold(
        appBar: AppBar(
          title: Text('Sweet Dreams'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent.shade700,
        ),
        backgroundColor: Colors.white,
        body: Container(
            child: ListView(
              children: <Widget>[
                TextField(),
                Padding(padding: EdgeInsets.all(5.0)),
                _mainPartView,
                Padding(padding: EdgeInsets.all(5.0)),
                _resultView
              ],
            ),
        ),
    );
  }

  ElevatedButton calculateButton() {
    return ElevatedButton(
      onPressed: _calculator,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent.shade700,
        textStyle: TextStyle(color: Colors.white70)
      ),
      child: Text(
        'Calculate',
        style: TextStyle(fontSize: 16.9),
      ),
    );
  }

  TextFormField sleepMinuteFormField() {
    return TextFormField(
      controller: _sleepMinuteController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      focusNode: _sleepMinuteFocus,
      onFieldSubmitted: (value){
        _sleepMinuteFocus.unfocus();
      },
      validator: (value) {
        if (value!.length == 0 || (double.parse(value) < 0 || double.parse(value) > 59)) {
          return ('Minute between 0 - 59');
        }
      },
      onSaved: (value) {
        _sleepMinute = value!;
      },
      decoration: InputDecoration(
          hintText: 'e.g.) 40',
          labelText: 'Minute',
          icon: Icon(Icons.assessment),
          fillColor: Colors.white
      ),
    );
  }

  TextFormField sleepHourFormField(BuildContext context) {
    return TextFormField(
      controller: _sleepHourController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      focusNode: _sleepHourFocus,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _sleepHourFocus, _sleepMinuteFocus);
      },
      validator: (value) {
        if (value!.length == 0 || (double.parse(value) < 1 || double.parse(value) > 12)) {
          return ('Hour between 1 - 12');
        }
      },
      onSaved: (value) {
        _sleepHour = value!;
      },
      decoration: InputDecoration(
        hintText: "e.g.) 7",
        labelText: "Hour",
        icon: Icon(Icons.assessment),
        fillColor: Colors.white,
      ),
    );
  }

  TextFormField hourFormField(BuildContext context) {
    return TextFormField(
      controller: _hourController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      focusNode: _hourFocus,
      onFieldSubmitted: (term){
        _fieldFocusChange(context, _hourFocus, _minuteFocus);
      },
      validator: (value) {
        if (value!.length == 0 || (double.parse(value) < 1 || double.parse(value) > 12)) {
          return ('Hour between 1 - 12');
        }
      },
      onSaved: (value) {
        _hour = value!;
      },
      decoration: InputDecoration(
        hintText: 'e.g.) 6',
        labelText: 'Hour',
        icon: Icon(Icons.assessment),
        fillColor: Colors.white,
      ),
    );
  }

  TextFormField cycleFormField(BuildContext context) {
    return TextFormField(
      controller: _cycleController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      focusNode: _cycleFocus,
      onFieldSubmitted: (term){
        _fieldFocusChange(context, _cycleFocus, _minuteFocus);
      },
      decoration: InputDecoration(
        hintText: 'e.g.) 2 cycles',
        labelText: 'Cycles',
        icon: Icon(Icons.assessment),
        fillColor: Colors.white,
      )
    );

  }

  TextFormField minFormField(BuildContext context) {
    return TextFormField(
      controller: _minuteController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      focusNode: _minuteFocus,
      onFieldSubmitted: (term){
        _fieldFocusChange(context, _minuteFocus, _sleepHourFocus);
      },
      validator: (value) {
        if (value!.length == 0 || (double.parse(value) < 0 || double.parse(value) > 59)) {
          return ('Minute between 0 - 59');
        }
      },
      onSaved: (value) {
        _minute = value!;
      },
      decoration: InputDecoration(
        hintText: 'e.g.) 30',
        labelText: 'Minute',
        icon: Icon(Icons.assessment),
        fillColor: Colors.white,
      ),
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


}

    **/
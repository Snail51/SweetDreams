import 'dart:async';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import 'package:units/widgetCalcModes.dart';
import 'package:time_range_picker/time_range_picker.dart';

class CalcPage extends StatefulWidget {
  CalcPage({Key? key, required this.database}) : super(key: key);

  SleepData database;

  @override
  _CalcPageState createState() => _CalcPageState();
}

class _CalcPageState extends State<CalcPage> {
  List<dynamic> content = [];
  List<Widget> displayables = [];
  List<String> sleepFacts = [
    "The longest recorded period without sleep is 11 days.",
    "Sleeping on your back can help prevent wrinkles.",
    "There are a total of 16 sleep cycles, each having a total time of 90 minutes.",
    "Newborns sleep up to 17 hours a day.",
    "Dolphins sleep with one eye open.",
    "Dreams are the result of your brain processing emotions and memories.",
    "The record for the most time spent without dreaming is 18 days, 21 hours, and 40 minutes.",
    "REM sleep is when most of our dreaming occurs.",
    "The average person falls asleep in about 7 minutes.",
    "Humans are the only mammals that willingly delay sleep.",
    "The ideal room temperature for sleeping is around 65 degrees Fahrenheit.",
    "Sleep deprivation can lead to weight gain.",
    "A good night's sleep can improve your memory and creativity.",
    "Sleep is essential for regulating hormones and maintaining a healthy immune system.",
    "Lack of sleep can impair judgement and decision-making.",
    "REM sleep helps to improve learning and memory.",
    "Snoring can be a sign of sleep apnea.",
    "Some animals, such as birds and some fish, sleep with only one half of their brain at a time.",
    "Sleepwalking is most common in children and tends to decrease with age.",
    "Chronic sleep deprivation has been linked to an increased risk of heart disease and stroke."
  ];
  String currentFact = "Did you know? " + "Sleeping on your back can help prevent wrinkles.";


  @override
  void initState() {
    super.initState();
    initContent();
    update();
    Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        currentFact = "Did you know? " + sleepFacts[DateTime.now().second % sleepFacts.length];
      });
    });
  }

  void update() {
    setState(() {
      List<Widget> holder = [];
      for (int i = 0; i < content.length; i++) {
        if (content[i].needsUpdating) {
          holder.add(content[i].toWidget());
          content[i].needsUpdating = false;
        } else {
          holder.add(displayables[i]);
        }
      }
      displayables = holder;
    });
  }

  void initContent() {
    content.add(CalcWakeWidget(context, updateCallback: update));
    content.add(CalcSleepWidget(context, updateCallback: update));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep Calculator"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: displayables,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.purple,
              child: Text(
                currentFact,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






/**
    class CalcPage extends StatefulWidget {
    CalcPage({Key? key, required this.database}) : super (key: key);
    // This widget is the home page of your application. It is stateful, meaning
    // that it has a State object (defined below) that contains fields that affect
    // how it looks.
    // This class is the configuration for the state. It holds the values (in this
    // case the title) provided by the parent (in this case the App widget) and
    // used by the build method of the State. Fields in a Widget subclass are
    // always marked "final".
    SleepData database = new SleepData(filename: "data.csv");
    @override
    _CalcPageState createState() => _CalcPageState();
    }
    class _CalcPageState extends State<CalcPage> {
    TimeOfDay _startTime = TimeOfDay.now();
    TimeOfDay _endTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 3)));
    double cycleLength = 90.00;
    double maxSleepCycle = 16;
    double? cycles;
    DateTime? fixedWake;
    DateTime? fixedSleep;
    DateTime? bestSleepTime;
    DateTime? bestWakeTime;
    List<dynamic> modes = [];
    List<Widget> displayables = [];
    void update()
    {
    setState(() {
    List<Widget> holder = [];
    for (int i = 0; i < modes.length; i++) {
    if(modes[i].needsUpdating)
    {
    holder.add(modes[i].toWidget());
    modes[i].needsUpdating = false;
    }
    else
    {
    holder.add(displayables[i]);
    }
    }
    displayables = holder;
    });
    }
    @override
    void initState() {
    initContent();
    update();
    super.initState();
    }
    void initContent()
    {
    modes.add(widgetModeWake("wake", context));
    }
    @override
    Widget build(BuildContext context) {
    final periodicTimer = Timer.periodic(
    const Duration(milliseconds: 200), //adjust this number for how often you want the screen refreshed
    (timer) {
    update();
    },
    );
    return Scaffold(
    appBar: AppBar(
    title: Text("Example of updating widgets that were dynamically created outside of a build function, because when they are outside of a build function they don't have access to setState()"),
    centerTitle: true,
    backgroundColor: Colors.blueAccent.shade700,
    ),
    backgroundColor: Colors.white,
    body: Center(
    child: Column(
    children: displayables,
    )
    ),
    );
    }
    }
    Widget modeWake() {
    final now = DateTime.now();
    final sleepCycle = 90;
    final maxCycles = 16;
    final cycleLength = Duration(minutes: sleepCycle);
    DateTime? fixedWake;
    List<Widget> content = [];
    String labelRangePickerButton = "Select Time Range";
    void updateWakeTime(TimeOfDay time) {
    fixedWake = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    print(fixedWake.toString());
    }
    void updateRangePickerButtonLabel(TimeOfDay input) {
    labelRangePickerButton = input.toString();
    }
    content.add(Text("Select Fixed Wake Time:"));
    content.add(
    ElevatedButton.icon(
    onPressed: () async {
    final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    );
    print("PICK" + picked.toString());
    if (picked != null) {
    setState(() {
    updateWakeTime(picked);
    });
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
    context: context,
    builder: (context) => AlertDialog(
    title: Text("Error"),
    content: Text("Please select a fixed wake time first."),
    ),
    );
    return;
    }
    final picked = await showTimeRangePicker(
    context: context,
    start: TimeOfDay(hour: fixedWake?.hour ?? TimeOfDay.now().hour, minute: fixedWake?.minute ?? TimeOfDay.now().minute),
    minDuration: Duration(minutes: 90),
    interval: Duration(minutes: 90),
    onStartChange: (time) {
    updateRangePickerButtonLabel(time);
    setState(() {
    _startTime = _startTime;
    });
    },
    onEndChange: (time) {
    updateRangePickerButtonLabel(time);
    setState(() {
    _endTime = time;
    });
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
    Widget modeSleep() {
    final now = DateTime.now();
    final sleepCycle = 90;
    final maxCycles = 16;
    final cycleLength = Duration(minutes: sleepCycle);
    DateTime? fixedSleep;
    List<Widget> content = [];
    String labelRangePickerButton = "Select Time Range";
    void updateSleepTime(TimeOfDay time) {
    fixedSleep = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    print(fixedWake.toString());
    }
    void updateRangePickerButtonLabel(TimeOfDay input) {
    labelRangePickerButton = input.toString();
    }
    content.add(Text("Select Fixed Wake Time:"));
    content.add(
    ElevatedButton.icon(
    onPressed: () async {
    final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    );
    print("PICK" + picked.toString());
    if (picked != null) {
    setState(() {
    updateSleepTime(picked);
    });
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
    "Selected Sleep Time: " + (fixedSleep?.toString() ?? ""),
    ),
    ),
    );
    content.add(
    SizedBox(
    width: 100,
    height: 100,
    child: Text(
    "Select sleep time range: ",
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
    if (fixedSleep == null) {
    // Show an error message if fixedWake is not set
    showDialog(
    context: context,
    builder: (context) => AlertDialog(
    title: Text("Error"),
    content: Text("Please select a fixed wake time first."),
    ),
    );
    return;
    }
    final picked = await showTimeRangePicker(
    context: context,
    start: TimeOfDay(hour: fixedSleep?.hour ?? TimeOfDay.now().hour, minute: fixedSleep?.minute ?? TimeOfDay.now().minute),
    minDuration: Duration(minutes: 90),
    interval: Duration(minutes: 90),
    onStartChange: (time) {
    updateRangePickerButtonLabel(time);
    setState(() {
    _startTime = _startTime;
    });
    },
    onEndChange: (time) {
    updateRangePickerButtonLabel(time);
    setState(() {
    _endTime = time;
    });
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
    Widget modeCycles() {
    final sleepCycle = 90;
    final maxCycles = 16;
    List<Widget> content = [];
    int selectedCycles = 1;
    double minRange = 0;
    double maxRange = (selectedCycles * 6) * sleepCycle.toDouble();
    content.add(Text("Select Number of Sleep Cycles:"));
    content.add(Slider(
    value: selectedCycles.toDouble(),
    min: 1,
    max: maxCycles.toDouble(),
    divisions: maxCycles - 1,
    label: selectedCycles.toString(),
    onChanged: (double value) {
    setState(() {
    selectedCycles = value.toInt();
    maxRange = (selectedCycles * 6) * sleepCycle.toDouble();
    });
    },
    ));
    content.add(
    SizedBox(
    width: 100,
    height: 100,
    child: Text(
    "Selected Cycles: " + selectedCycles.toString(),
    ),
    ),
    );
    content.add(
    SizedBox(
    width: 100,
    height: 100,
    child: Text(
    "Select Sleep time range: ",
    ),
    ),
    );
    content.add(
    SizedBox(
    height: 100,
    child: RangeSlider(
    values: RangeValues(minRange, maxRange),
    min: 0,
    max: (maxCycles * 6) * sleepCycle.toDouble(),
    onChanged: (RangeValues values) {
    setState(() {
    minRange = values.start;
    maxRange = values.end;
    });
    },
    ),
    ),
    );
    return Column(
    children: content,
    );
    }
    @override
    Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Text('Sleep Calculator'),
    ),
    body: SingleChildScrollView(
    padding: EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Select a mode:',
    style: TextStyle(fontSize: 18.0),
    ),
    SizedBox(height: 16.0),
    ElevatedButton(
    onPressed: () {
    showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
    return modeWake();
    },
    );
    },
    child: Text('Fixed Wake Time'),
    ),
    ElevatedButton(
    onPressed: () {
    showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
    return modeSleep();
    }
    );
    },
    child: Text('Fixed Sleep Time'),
    ),
    ElevatedButton(
    onPressed: () {
    showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
    return modeCycles();
    }
    );
    },
    child: Text('Sleep Cycles'),
    ),
    SizedBox(height: 8.0),
    SizedBox(height: 16.0),
    if (fixedWake != null)
    Text('Selected Wake Time: ${fixedWake!.hour}:${fixedWake!
    .minute}'),
    if (fixedSleep != null)
    Text('Selected Sleep Time: ${fixedSleep!.hour}:${fixedSleep!
    .minute}'),
    if (cycles != null)
    Text('Selected Sleep Time: ${_startTime.format(
    context)} - ${_endTime.format(context)}'),
    ],
    ),
    ),
    );
    }
    }
 **/









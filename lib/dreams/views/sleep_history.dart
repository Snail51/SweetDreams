
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:units/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:units/database.dart';

class SleepHistory extends StatefulWidget {
  SleepHistory({Key? key, required this.sleepEntries}) : super(key: key);
  final List<SleepEntry> sleepEntries;

  @override
  _SleepHistoryState createState() => _SleepHistoryState();
}

class _SleepHistoryState extends State<SleepHistory> {
  List<SleepEntry> get sleepHistory => widget.sleepEntries;

  DateTime selectedDate = DateTime.fromMicrosecondsSinceEpoch(0);
  DateTime selectedDate2 = DateTime.now();
  String startSelectButton = "Graph Start Date";
  String endSelectButton = "Graph End Date";
  bool startSelected = false;
  bool endSelected = false;

  BarChart chart = BarChart(BarChartData());

  double calculateAverageSleep() {
    double totalDuration = widget.sleepEntries.fold(0, (sum, entry) => sum + entry.duration.abs());
    return totalDuration / widget.sleepEntries.length;
  }

  BarChart getChart(List<SleepEntry> entries) {
    print("GETTING CHART");
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 24,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => TextStyle(color: Colors.blueGrey, fontSize: 14),
            getTitles: (double value) {
              return entries[value.toInt()].date.toString().split(' ')[0];
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => TextStyle(color: Colors.blueGrey, fontSize: 7),
            getTitles: (double value) {
              return value.toInt().toString();
            },
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: entries
            .asMap()
            .map((index, entry) => MapEntry(
          index,
          BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(y: entry.duration, colors: [Colors.lightBlueAccent, Colors.blueAccent]),
            ],
          ),
        ))
            .values
            .toList(),
      ),
    );
  }

  updateChart() async{
    print("UPDATING CHART");
    List<SleepEntry> filteredList = [];
    for(int i = 0; i < sleepHistory.length; i++) {
      if(sleepHistory[i].date.isBefore(selectedDate2) && sleepHistory[i].date.isAfter(selectedDate)) {
        filteredList.add(sleepHistory[i]);
      }
    }
    setState(() {
      chart = getChart(filteredList);
    });
  }

  @override
  Widget build(BuildContext context) {
    double averageSleep = calculateAverageSleep();

    _selectDate1(BuildContext context) async{ //Date Picker Popup
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), // Refer step 1
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
      if (picked != null && picked != selectedDate && picked.isBefore(selectedDate2)) {
        setState(() {
          selectedDate = picked.add(Duration(hours: 12));
          startSelectButton = DateFormat.MMMd().format(selectedDate) + ", " +
              DateFormat.y().format(selectedDate);
          startSelected = true;
        });
      }
      if (startSelected && endSelected) {
        updateChart();
      }
    }

    _selectDate2(BuildContext context) async{ //Date Picker Popup
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), // Refer step 1
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
      if (picked != null && picked != selectedDate2 && picked.isAfter(selectedDate)) {
        setState(() {
          selectedDate2 = picked.add(Duration(hours: 12));
          endSelectButton = DateFormat.MMMd().format(selectedDate2) + ", " +
              DateFormat.y().format(selectedDate2);
          endSelected = true;
        });
      }
      if (startSelected && endSelected) {
        updateChart();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Analytics'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Average Sleep Duration: ${averageSleep.toStringAsFixed(1)} hours',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 200,
              padding: EdgeInsets.all(16),
              child: chart
            ),
            Padding(
              padding: EdgeInsets.only(left: 47),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple
                      ),
                      child: Text(startSelectButton),
                      onPressed: () => _selectDate1(context)
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple
                      ),
                      child: Text(endSelectButton),
                      onPressed: () => _selectDate2(context)
                  ),
                  //IconButton(onPressed: () => deleteLastLog(), icon: const Icon(Icons.delete_forever), color: Colors.deepPurple,) // Update this line
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SleepEntry {
  final DateTime date;
  final double duration;

  SleepEntry(this.date, this.duration);
}
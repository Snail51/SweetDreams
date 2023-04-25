import 'dart:math';
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
  bool startUp = true;
  double averageSleep = 0.0;
  double maxDuration = 24.0;

  BarChart chart = BarChart(BarChartData());

  double calculateAverageSleep(List<SleepEntry> entries) {
    //double totalDuration = entries.fold(0, (sum, entry) => sum + entry.duration.abs());
    double totalDuration = 0.0;
    for (int i = 0; i < entries.length; i++) {
      totalDuration += entries[i].duration.abs();
    }
    return totalDuration / entries.length;
  }
  //custom comparator from: https://stackoverflow.com/questions/53547997/sort-a-list-of-objects-in-flutter-dart-by-property-value
  int sortDates(SleepEntry a, SleepEntry b) {
    final timeA = a.date;
    final timeB = b.date;

    if (timeA.isBefore(timeB)) {
      return -1;
    } else if (timeB.isBefore(timeA)) {
      return 1;
    } else {
      return 0;
    }
  }

  BarChart getChart(List<SleepEntry> entries) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        minY: 0,
        maxY: maxDuration,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey.shade700,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.y.round().toString(),
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) =>
                TextStyle(color: Colors.white, fontSize: 14),
            getTitles: (double value) {
              return entries[value.toInt()].date.toString().split(' ')[0];
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) =>
                TextStyle(color: Colors.white, fontSize: 14),
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
                      BarChartRodData(
                        y: entry.duration,
                        borderRadius: BorderRadius.circular(10),
                        colors: [Colors.deepPurpleAccent, Colors.deepPurple],
                        width: 16,
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          y: maxDuration,
                          colors: [Colors.grey.shade600],
                        ),
                      ),
                    ],
                  ),
                ))
            .values
            .toList(),
      ),
      swapAnimationDuration: Duration(milliseconds: 500),
      swapAnimationCurve: Curves.easeInOut,
    );
  }

  updateChart() async {
    print("UPDATING CHART");
    List<SleepEntry> filteredList = [];
    for (int i = 0; i < sleepHistory.length; i++) {
      if ((sleepHistory[i].date.isBefore(selectedDate2) ||
              sleepHistory[i].date.isAtSameMomentAs(selectedDate2)) &&
          (sleepHistory[i].date.isAfter(selectedDate) ||
              sleepHistory[i].date.isAtSameMomentAs(selectedDate))) {
        filteredList.add(sleepHistory[i]);
      }
    }
    filteredList.sort(sortDates);
    setState(() {
      chart = getChart(filteredList);
      averageSleep = calculateAverageSleep(filteredList);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (startUp) {
      chart = getChart(sleepHistory);
      averageSleep = calculateAverageSleep(sleepHistory);
      startUp = false;
    }
    _selectDate1(BuildContext context) async {
      //Date Picker Popup
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
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
      if (picked != null &&
          picked != selectedDate &&
          picked.isBefore(selectedDate2)) {
        setState(() {
          selectedDate = picked.add(Duration(hours: 12));
          startSelectButton = DateFormat.MMMd().format(selectedDate) +
              ", " +
              DateFormat.y().format(selectedDate);
          startSelected = true;
        });
      }
      if (startSelected && endSelected) {
        updateChart();
      }
    }

    _selectDate2(BuildContext context) async {
      //Date Picker Popup
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
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
      if (picked != null &&
          picked != selectedDate2 &&
          picked.isAfter(selectedDate)) {
        setState(() {
          selectedDate2 = picked.add(Duration(hours: 12));
          endSelectButton = DateFormat.MMMd().format(selectedDate2) +
              ", " +
              DateFormat.y().format(selectedDate2);
          endSelected = true;
        });
      }
      if (startSelected && endSelected) {
        updateChart();
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text('Sleep Analytics'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Average Sleep Duration: ${averageSleep.toStringAsFixed(1)} hours',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height *
                    0.7, // Adjust height to fill the available space
                padding: EdgeInsets.all(16),
                child: chart),
            Padding(
              padding: EdgeInsets.only(left: 47),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple),
                        child: Text(startSelectButton),
                        onPressed: () => _selectDate1(context)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple),
                        child: Text(endSelectButton),
                        onPressed: () => _selectDate2(context)),
                  )
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

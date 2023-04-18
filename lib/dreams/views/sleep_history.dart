import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepHistory extends StatefulWidget {
  SleepHistory({Key? key, required this.sleepEntries}) : super(key: key);
  final List<SleepEntry> sleepEntries;

  @override
  _SleepHistoryState createState() => _SleepHistoryState();
}

class _SleepHistoryState extends State<SleepHistory> {
  List<SleepEntry> get sleepHistory => widget.sleepEntries;

  double calculateAverageSleep() {
    double totalDuration = widget.sleepEntries.fold(0, (sum, entry) => sum + entry.duration);
    return totalDuration / widget.sleepEntries.length;
  }

  @override
  Widget build(BuildContext context) {
    double averageSleep = calculateAverageSleep();

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
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => TextStyle(color: Colors.blueGrey, fontSize: 14),
                      getTitles: (double value) {
                        return sleepHistory[value.toInt()].date.toString().split(' ')[0];
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => TextStyle(color: Colors.blueGrey, fontSize: 14),
                      getTitles: (double value) {
                        return value.toInt().toString();
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: sleepHistory
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
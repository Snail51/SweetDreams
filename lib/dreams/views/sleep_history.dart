import 'dart:math';

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
    double totalDuration = widget.sleepEntries.fold(
        0, (sum, entry) => sum + entry.duration.abs());
    return totalDuration / widget.sleepEntries.length;
  }

  @override
  Widget build(BuildContext context) {
    double averageSleep = calculateAverageSleep();

    List<double> durations = sleepHistory.map((entry) => entry.duration)
        .toList();
    double maxDuration = durations.reduce(max);

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text('Sleep Analytics'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Average Sleep Duration: ${averageSleep.toStringAsFixed(
                    1)} hours',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.7, // Adjust height to fill the available space
              padding: EdgeInsets.all(16),
              child: BarChart(
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
                          TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                        return sleepHistory[value.toInt()].date.toString()
                            .split(' ')[0];
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
                  barGroups: sleepHistory
                      .asMap()
                      .map((index, entry) =>
                      MapEntry(
                        index,
                        BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              y: entry.duration,
                              borderRadius: BorderRadius.circular(10),
                              colors: [
                                Colors.lightBlueAccent,
                                Colors.blueAccent
                              ],
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
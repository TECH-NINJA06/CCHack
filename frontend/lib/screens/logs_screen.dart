import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LogsScreen extends StatelessWidget {
  final Map<String, int> weeklyEmotions = {
    'Mon': 1,
    'Tue': 2,
    'Wed': 1,
    'Thu': 3,
    'Fri': 2,
    'Sat': 1,
    'Sun': 0,
  };

  LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Logs")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 5,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    return Text(days[value.toInt()]);
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(7, (i) {
              return BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                  toY: weeklyEmotions.values.elementAt(i).toDouble(),
                  color: Colors.green,
                  width: 20,
                ),
              ]);
            }),
          ),
        ),
      ),
    );
  }
}

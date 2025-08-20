import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyComparisonChart extends StatelessWidget {
  const MonthlyComparisonChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 5000,
        barTouchData: BarTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 3000,
                color: Colors.green,
                width: 20,
              ),
              BarChartRodData(
                toY: 2000,
                color: Colors.red,
                width: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
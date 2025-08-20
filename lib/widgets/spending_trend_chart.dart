import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SpendingTrendChart extends StatelessWidget {
  final Map<String, double> monthlyData;
  final Color primaryColor;

  const SpendingTrendChart({
    super.key,
    required this.monthlyData,
    this.primaryColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    if (monthlyData.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withValues(alpha: 0.3),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withValues(alpha: 0.3),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < monthlyData.keys.length) {
                    final monthKey = monthlyData.keys.elementAt(index);
                    final date = DateTime.parse('$monthKey-01');
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        DateFormat('MMM').format(date),
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: null,
                reservedSize: 42,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      '\$${value.toInt()}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          minX: 0,
          maxX: (monthlyData.length - 1).toDouble(),
          minY: 0,
          maxY: monthlyData.values.isNotEmpty
              ? monthlyData.values.reduce((a, b) => a > b ? a : b) * 1.2
              : 100,
          lineBarsData: [
            LineChartBarData(
              spots: monthlyData.entries
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value.value,
                      ))
                  .toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withValues(alpha: 0.7),
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: primaryColor,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryColor.withValues(alpha: 0.3),
                    primaryColor.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
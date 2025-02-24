import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesRevenueChart extends StatelessWidget {
  const SalesRevenueChart({super.key, required this.isShowingMainData});

  final bool isShowingMainData;
sampleData1(){
  return LineChartData(
    lineTouchData:  lineTouchData1(),
    gridData: getGridData(),

  );
}
  FlGridData getGridData() {
    return const FlGridData(show: false);
  }

lineTouchData1(){
  return LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) =>
          Colors.blueGrey.withValues(alpha: 0.8),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1(),
      duration: const Duration(milliseconds: 250),
    );
  }
}

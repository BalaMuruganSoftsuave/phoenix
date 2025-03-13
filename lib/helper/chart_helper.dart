//
// import 'package:flutter/material.dart';
// import 'package:phoenix/screens/charts/line_chart.dart';
//
// ChartModel convertApiToChartModel(Map<String, dynamic> apiData) {
//   List<dynamic> result = apiData['Result'] ?? [];
//
//   // Initialize dynamic maps
//   Map<String, List<ChartPoint>> dataPoints = {};
//   Map<String, double> totalValues = {};
//
//   if (result.isNotEmpty) {
//     // Extract keys dynamically from the first entry
//     result.first.keys.forEach((key) {
//       if (key != 'Range') {
//         dataPoints[key] = [];
//         totalValues[key] = 0;
//       }
//     });
//   }
//
//   // Loop through API data and populate data points
//   for (int i = 0; i < result.length; i++) {
//     var entry = result[i];
//     entry.forEach((key, value) {
//       if (key != 'Range' && value != null) {
//         dataPoints[key]?.add(ChartPoint(x: i.toDouble(), y: value.toDouble()));
//         totalValues[key] = totalValues[key]! + value.toDouble();
//       }
//     });
//   }
//
//   // Generate legend data dynamically
//   List<ChartData> legendData = totalValues.entries.map((entry) {
//     return ChartData(
//       label: entry.key,
//       value: entry.value,
//       color: getRandomColor(entry.key),
//     );
//   }).toList();
//
//   return ChartModel(
//     dataPoints: dataPoints,
//     legendData: legendData,
//   );
// }
//
// // Function to generate consistent color based on key
// Color getRandomColor(String key) {
//   int hash = key.hashCode;
//   return Color((hash & 0xFFFFFF) | 0xFF000000); // Ensure full opacity
// }

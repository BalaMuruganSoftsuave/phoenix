
// Colors for bars
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';

const Color voidColor = AppColors.purple;
const Color revenueColor = AppColors.pink;
const Color refundColor = AppColors.seaBlue;

// Data model to convert raw values into percentages
class ChartData {
  final String range;
  final Map<String, double> values; // Stores raw values
  final Map<String, double> percentages; // Stores percentage values

  ChartData({
    required this.range,
    required this.values,
    required this.percentages,
  });
}

List<ChartData> processData(List<Map<String, dynamic>> data) {
  return data.map((entry) {
    String range = entry['Range'].toString();

    // Extract values dynamically
    List<String> keys = entry.keys.where((key) => key != 'Range').toList();
    Map<String, double> values = {
      for (var key in keys) key: (entry[key] as num).toDouble(),
    };

    // Calculate total sum for the date
    double total = values.values.fold(0, (sum, value) => sum + value);

    // Calculate percentages
    Map<String, double> percentages = {
      for (var key in keys) key: total > 0 ? (values[key]! / total) * 100 : 0,
    };
    return ChartData(range: range, values: values, percentages: percentages);
  }).toList();
}


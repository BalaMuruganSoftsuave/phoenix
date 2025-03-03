
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
  final double voidPercentage;
  final double revenuePercentage;
  final double refundPercentage;
  final double voidValue;
  final double revenueValue;
  final double refundValue;

  ChartData({
    required this.range,
    required this.voidPercentage,
    required this.revenuePercentage,
    required this.refundPercentage,
    required this.voidValue,
    required this.revenueValue,
    required this.refundValue,
  });
}

List<ChartData> processData(List<Map<String, dynamic>> data) {
  return data.map((entry) {
    double voidValue = (entry['Void'] as num).toDouble();
    double revenueValue = (entry['Revenue'] as num).toDouble();
    double refundValue = (entry['Refund'] as num).toDouble();

    // Correct total calculation
    double total = voidValue + revenueValue + refundValue;

    // Avoid division by zero
    double voidPercentage = (total > 0) ? (voidValue / total) * 100 : 0;
    double revenuePercentage = (total > 0) ? (revenueValue / total) * 100 : 0;
    double refundPercentage = (total > 0) ? (refundValue / total) * 100 : 0;

    return ChartData(
      range: entry['Range'].toString(),
      voidPercentage: voidPercentage,
      revenuePercentage: revenuePercentage,
      refundPercentage: refundPercentage,
      voidValue: voidValue,
      revenueValue: revenueValue,
      refundValue: refundValue,
    );
  }).toList();
}


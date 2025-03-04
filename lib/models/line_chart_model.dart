import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


import '../helper/color_helper.dart';
import '../helper/utils.dart';


class SalesData {
  final String range;
  final double directSale;
  final double upsellSale;
  final double initialSale;
  final double recurringSale;
  final double salvageSale;


  SalesData({
    required this.range,
    required this.directSale,
    required this.upsellSale,
    required this.initialSale,
    required this.recurringSale,
    required this.salvageSale,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      range: json['Range'],
      directSale: (json['DirectSale'] as num).toDouble(),
      upsellSale: (json['UpsellSale'] as num).toDouble(),
      initialSale: (json['InitialSale'] as num).toDouble(),
      recurringSale: (json['RecurringSale'] as num).toDouble(),
      salvageSale: (json['SalvageSale'] as num).toDouble(),
    );
  }
}
class LineChartModel {
  final List<SalesData> salesData; // Store sales data
  final Map<String, List<FlSpot>> dataPoints;
  final Map<String, Color> lineColors;

  LineChartModel( {required this.dataPoints, this.lineColors = const {},required this.salesData});


  static LineChartModel fromSalesData(List<SalesData> salesData) {
    Map<String, List<FlSpot>> points = {
      'Direct Sale': [],
      'Upsell Sale': [],
      'Initial Sale': [],
      'Recurring Sale': [],
      'Salvage Sale': []
    };

    for (int i = 0; i < salesData.length; i++) {
      points['Direct Sale']!.add(FlSpot(i.toDouble(), salesData[i].directSale));
      points['Upsell Sale']!.add(FlSpot(i.toDouble(), salesData[i].upsellSale));
      points['Initial Sale']!.add(FlSpot(i.toDouble(), salesData[i].initialSale));
      points['Recurring Sale']!.add(FlSpot(i.toDouble(), salesData[i].recurringSale));
      points['Salvage Sale']!.add(FlSpot(i.toDouble(), salesData[i].salvageSale));
    }

    Map<String, Color> colors = {
      'Direct Sale': AppColors.pink,
      'Upsell Sale': AppColors.successGreen,
      'Initial Sale': AppColors.seaBlue,
      'Recurring Sale': AppColors.purple  ,
      'Salvage Sale': AppColors.orange
    };

    return LineChartModel(salesData:salesData,dataPoints: points, lineColors: colors);
  }
}


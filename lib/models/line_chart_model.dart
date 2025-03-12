import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../helper/color_helper.dart';

class SalesData {
  final String? range;
  final double? directSale;
  final double? upsellSale;
  final double? initialSale;
  final double? recurringSale;
  final double? salvageSale;


  SalesData({
     this.range,
     this.directSale,
     this.upsellSale,
     this.initialSale,
     this.recurringSale,
     this.salvageSale,

  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      range: json['Range'],
      directSale: (json['DirectSale'] ?? 0).toDouble(),
      upsellSale: (json['UpsellSale'] ?? 0).toDouble(),
      initialSale: (json['InitialSale'] ?? 0).toDouble(),
      recurringSale: (json['RecurringSale'] ?? 0).toDouble(),
      salvageSale: (json['SalvageSale'] ?? 0).toDouble(),

    );
  }
}
class SubscriptionData {
  final String? range;
  final int? newSubscriptions;
  final int? cancelledSubscriptions;
  final int? netSubscriptions;

  SubscriptionData({
     this.range,
     this.newSubscriptions,
     this.cancelledSubscriptions,
     this.netSubscriptions,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      range: json['Range'],
      newSubscriptions: json['NewSubscriptions'],
      cancelledSubscriptions: json['CancelledSubscriptions'],
      netSubscriptions: json['NetSubscriptions'],
    );
  }
}


class LineChartModel {
  final List<SalesData>? salesData;
  final List<SubscriptionData>? subscriptionData; // New dataset

  final Map<String, List<FlSpot>> dataPoints;
  final Map<String, Color> lineColors;

  LineChartModel({
     this.salesData,
    this.subscriptionData,

    required this.dataPoints,
    this.lineColors = const {},
  });

  static LineChartModel fromSalesData(List<SalesData> salesData) {
    Map<String, List<FlSpot>> points = {
      'Direct Sale': [],
      'Upsell Sale': [],
      'Initial Sale': [],
      'Recurring Sale': [],
      'Salvage Sale': [],

    };

    for (int i = 0; i < salesData.length; i++) {
      points['Direct Sale']?.add(FlSpot(i.toDouble(), salesData[i].directSale??0));
      points['Upsell Sale']?.add(FlSpot(i.toDouble(), salesData[i].upsellSale??0));
      points['Initial Sale']?.add(FlSpot(i.toDouble(), salesData[i].initialSale??0));
      points['Recurring Sale']?.add(FlSpot(i.toDouble(), salesData[i].recurringSale??0));
      points['Salvage Sale']?.add(FlSpot(i.toDouble(), salesData[i].salvageSale??0));

    }

    Map<String, Color> colors = {
      'Direct Sale': AppColors.pink,
      'Upsell Sale': AppColors.successGreen,
      'Initial Sale': AppColors.seaBlue,
      'Recurring Sale': AppColors.purple,
      'Salvage Sale': AppColors.orange,

    };

    return LineChartModel(salesData: salesData, dataPoints: points, lineColors: colors);
  }

  /// Create model for Subscription Data
  static LineChartModel fromSubscriptions(List<SubscriptionData> subscriptionData) {
    Map<String, List<FlSpot>> points = {
      'New Subscriptions': [],
      'Cancelled Subscriptions': [],
      'Net Subscriptions': []
    };

    for (int i = 0; i < subscriptionData.length; i++) {
      points['New Subscriptions']?.add(FlSpot(i.toDouble(), subscriptionData[i].newSubscriptions?.toDouble()??0));
      points['Cancelled Subscriptions']?.add(FlSpot(i.toDouble(), subscriptionData[i].cancelledSubscriptions?.toDouble()??0));
      points['Net Subscriptions']?.add(FlSpot(i.toDouble(), subscriptionData[i].netSubscriptions?.toDouble()??0));
    }

    return LineChartModel(
      subscriptionData: subscriptionData,
      dataPoints: points,
      lineColors: {
        'New Subscriptions': AppColors.successGreen,
        'Cancelled Subscriptions': AppColors.seaBlue,
        'Net Subscriptions': AppColors.pink,
      },
    );
  }
}


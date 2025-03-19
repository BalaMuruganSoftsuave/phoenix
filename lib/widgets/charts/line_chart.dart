import 'dart:core';
import 'dart:math' as Math;

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/models/line_chart_model.dart';
import 'package:phoenix/widgets/charts/legend_widget.dart';

import '../../helper/color_helper.dart';
import '../../helper/dependency.dart';

class SalesRevenueChart extends StatelessWidget {
  const SalesRevenueChart({
    super.key,
    this.areaMap = false,
    required this.chartModel,
    this.isDetailScreen = false,
  });

  final bool areaMap;
  final bool isDetailScreen;
  final LineChartModel chartModel;

  @override
  Widget build(BuildContext context) {
    final totalSales = isDetailScreen
        ? _calculateDirectSales()
        : _calculateTotalSales(); // Calculate totals for legend
    final totalSubs = _calculateTotalSubscriptions(chartModel.subscriptionData);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: Container(
            width: Math.max(
              MediaQuery.of(context).size.width,
              ((areaMap
                          ? (chartModel.salesData?.length ?? 0)
                          : (chartModel.subscriptionData?.length ?? 0)) *
                      50)
                  .toDouble(),
            ),
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              sampleData1(),
              // curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 250),
            ),
          ),
        ),
        const SizedBox(height: 10),
        isDetailScreen
            ? Wrap(
                alignment: WrapAlignment.start,
                // Align items from the start
                spacing: 10,
                // Horizontal spacing between items
                runSpacing: 10,
                // Vertical spacing between wrapped rowstween wrapped rows
                children: [
                  LegendWidget(
                      color: AppColors.pink,
                      text: 'Direct',
                      subText: formatCurrency(totalSales['Direct Sale'] ?? 0)
                          .toString()),
                ],
              )
            : areaMap
                ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: totalSales.entries.map((entry) {
                      Color color = _getLegendColor(entry.key);
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 24) /
                            2.3, // 2 items per row
                        child: LegendWidget(
                          color: color,
                          text: entry.key,
                          subText: formatCurrency(entry.value ?? 0).toString(),
                        ),
                      );
                    }).toList(),
                  )
                : Wrap(
                    alignment:
                        WrapAlignment.start, // Align items from the start
                    spacing: 30, // Horizontal spacing between items
                    runSpacing: 15,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: LegendWidget(
                                color: AppColors.pink,
                                text: 'Net Subscribers',
                                subText: (totalSubs['netSubscriptions'] ?? 0)
                                    .toString()),
                          ),
                          Expanded(
                            child: LegendWidget(
                                color: AppColors.successGreen,
                                text: 'New Subscribers',
                                subText: (totalSubs['newSubscriptions'] ?? 0)
                                    .toString()),
                          ),
                        ],
                      ),
                      LegendWidget(
                          color: AppColors.seaBlue,
                          text: 'Cancelled Subscribers',
                          subText: (totalSubs['cancelledSubscriptions'] ?? 0)
                              .toString()),
                    ],
                  )
      ],
    );
  }

  Color _getLegendColor(String key) {
    switch (key) {
      case 'Direct Sale':
        return AppColors.pink;
      case 'Upsell Sale':
        return AppColors.successGreen;
      case 'Initial Sale':
        return AppColors.seaBlue;
      case 'Recurring Sale':
        return AppColors.purple;
      case 'Salvage Sale':
        return AppColors.orange;
      default:
        return Colors.grey;
    }
  }

  String formatRange(String? range) {
    if (range == null || range.isEmpty) return "";

    List<String> parts = range.split(" ");

    // If there's a time (AM/PM), return only the time
    if (parts.length > 1 &&
        RegExp(r'^\d{1,2}(AM|PM|am|pm)$').hasMatch(parts.last)) {
      return parts.last;
    }

    // If it's just a date (e.g., "3/10", "Jan 24"), return it as is
    return range;
  }

  /// Function to calculate total sales for each category
  Map<String, double> _calculateTotalSales() {
    final totals = <String, double>{
      "Direct Sale": 0,
      "Upsell Sale": 0,
      "Initial Sale": 0,
      "Recurring Sale": 0,
      "Salvage Sale": 0,
    };

    for (var entry in chartModel.salesData ?? []) {
      totals["Direct Sale"] = (totals["Direct Sale"] ?? 0) + entry.directSale;
      totals["Upsell Sale"] = (totals["Upsell Sale"] ?? 0) + entry.upsellSale;
      totals["Initial Sale"] =
          (totals["Initial Sale"] ?? 0) + entry.initialSale;
      totals["Recurring Sale"] =
          (totals["Recurring Sale"] ?? 0) + entry.recurringSale;
      totals["Salvage Sale"] =
          (totals["Salvage Sale"] ?? 0) + entry.salvageSale;
    }

    return totals;
  }

  Map<String, double> _calculateDirectSales() {
    final totals = <String, double>{
      "Direct Sale": 0,
    };

    for (var entry in chartModel.directData ?? []) {
      totals["Direct Sale"] = (totals["Direct Sale"] ?? 0) + entry.directSale;
    }

    return totals;
  }

  Map<String, num> _calculateTotalSubscriptions(
      List<SubscriptionData>? subscriptionData) {
    final totals = <String, num>{
      "netSubscriptions": 0,
      "newSubscriptions": 0,
      "cancelledSubscriptions": 0,
    };

    for (var entry in subscriptionData ?? []) {
      totals["netSubscriptions"] =
          (totals["netSubscriptions"] ?? 0) + (entry.netSubscriptions ?? 0);
      totals["newSubscriptions"] =
          (totals["newSubscriptions"] ?? 0) + (entry.newSubscriptions ?? 0);
      totals["cancelledSubscriptions"] =
          (totals["cancelledSubscriptions"] ?? 0) +
              (entry.cancelledSubscriptions ?? 0);
    }

    return totals;
  }

  // Find the overall min/max across all data series

  LineChartData sampleData1() {
    List<FlSpot> spots = [];
    double minY = 0;
    double maxY = 0;

    for (var entry in chartModel.dataPoints.entries) {
      double xValue = double.tryParse(entry.key) ?? 0;
      spots.addAll(entry.value.map((spot) => FlSpot(xValue, spot.y)));
    }

    if (spots.isNotEmpty) {
      minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
      maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

      // Ensure we include zero
      // minY = minY > 0 ? 0 : minY;
      // Add some padding at the top
      maxY = (maxY * 1.1).ceilToDouble();
    }

    return LineChartData(
      minY: minY,
      maxY: maxY,
      lineTouchData: lineTouchData1(),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        horizontalInterval: Math.max((maxY - minY) / 3, 1),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.lines,
            strokeWidth: 1, // Thin but visible
            dashArray: null, // Ensures solid line (not dotted)
          );
        },
      ),
      titlesData: getTitlesData(spots),
      borderData: FlBorderData(
        show: false,
        border: const Border(
          left: BorderSide(color: Colors.white, width: 1),
          bottom: BorderSide(color: Colors.white, width: 1),
        ),
      ),
      lineBarsData: chartModel.dataPoints.entries.map((entry) {
        int calculateWindowSize(List<FlSpot> spots) {
          int length = spots.length;

          // if (length < 10) return 3; // Minimum window size
          return (length * 0.1).round().clamp(1, length); // 10% of data, min 3
        }
        // List<FlSpot> smoothedSpots =
        //     smoothData(entry.value, calculateWindowSize(entry.value)); // Using window size of 15

        return LineChartBarData(
          preventCurveOverShooting: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              // Show dots only at every 5th point
              return FlDotCirclePainter(radius: 2, color: Colors.white);
            },
          ),
          curveSmoothness: 0.4,
          // spots: normalizeAndReducePoints(entry.value,14,2000,5),
          spots: entry.value,
          isCurved: true,
          color: chartModel.lineColors[entry.key],
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: areaMap,
            gradient: LinearGradient(
              begin: Alignment.topCenter, // Starts from the top
              end: Alignment.bottomCenter, // Fades downwards
              colors: [
                chartModel.lineColors[entry.key]!.withValues(alpha: 0.8),
                // Start with some opacity
                // chartModel.lineColors[entry.key]!.withOpacity(0.1), // Fully transparent at the bottom
                AppColors.darkBg2.withValues(alpha: 0.0)
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  FlGridData getGridData() {
    return const FlGridData(show: false);
  }

  FlTitlesData getTitlesData(List<FlSpot> spots) {
    double minY = 0;
    double maxY = 0;

    if (spots.isNotEmpty) {
      minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
      maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

      minY = (minY > 0) ? 0 : minY;
      maxY = (maxY * 1.1).ceilToDouble(); // Add 10% padding at the top
    }

    String formatValue(double value) {
      if (value.abs() >= 1000000000) {
        return '${(value / 1000000000).toStringAsFixed(1)}B'; // Billion (e.g., 3.2B, -3.2B)
      } else if (value.abs() >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)}M'; // Million (e.g., 5.5M, -5.5M)
      } else if (value.abs() >= 100000) {
        return '${(value / 1000).toStringAsFixed(0)}K'; // Thousands (e.g., 200K, -200K)
      } else if (value.abs() >= 1000) {
        return '${(value / 1000).toStringAsFixed(1)}K'; // Thousands with 1 decimal (e.g., 1.2K, -1.2K)
      } else {
        return NumberFormat("#,##0")
            .format(value); // Default with commas (e.g., -950 → "-950")
      }
    }

    double interval;
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          maxIncluded: true,
          minIncluded: true,
          reservedSize: Responsive.padding(getCtx()!, 10),
          getTitlesWidget: (value, meta) {
            double absMax = Math.max(
                minY.abs(), maxY.abs()); // Get the larger absolute value
            interval = absMax / 2;

            List<double> valuesToShow = [
              minY, // Ensure minY is included
              -absMax, // Most negative value
              -interval, // Middle negative value
              0, // Zero
              interval, // Middle positive value
              maxY // Most positive value
            ];

            valuesToShow = valuesToShow
                .map((v) => double.parse(v.toStringAsFixed(1)))
                .toList();

            // Only show our specific values
            if (valuesToShow.contains(value)) {
              return Text(
                formatValue(value),
                style:  getTextTheme().bodyMedium?.copyWith(fontSize: 10, color: Colors.white),
              );
            }
            return Container(); // Hide other values
          },
          interval: Math.max((maxY - minY) / 2, 0.1),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            interval: 1,
            getTitlesWidget: (value, meta) {
              // Process only whole integer values
              if (value % 1 != 0) return Container();

              int index = value.toInt();

              // Get actual data length safely
              int dataLength = isDetailScreen
                  ? (chartModel.directData?.length ?? 0)
                  : areaMap
                      ? (chartModel.salesData?.length ?? 0)
                      : (chartModel.subscriptionData?.length ?? 0);
              // Ensure index is within bounds
              if (index < 0 || index >= dataLength) {
                return Container(); // Return an empty widget if out of bounds
              }

              int lastIndex = dataLength > 0 ? dataLength - 1 : 0;

              if (dataLength < 5) {
                // Show all labels if length is less than 5
                String? range;
                if (areaMap &&
                    chartModel.salesData != null &&
                    index < chartModel.salesData!.length) {
                  range = chartModel.salesData?[index].range;
                } else if (!areaMap &&
                    chartModel.subscriptionData != null &&
                    index < chartModel.subscriptionData!.length) {
                  range = chartModel.subscriptionData?[index].range;
                } else if (isDetailScreen &&
                    chartModel.directData != null &&
                    index < (chartModel.directData?.length ?? 0)) {
                  range = chartModel.directData?[index].range;
                } else {
                  range = "";
                }

                return Text(
                  formatRange(range),
                  style: getTextTheme().bodyMedium?.copyWith(fontSize: 10, color: Colors.white),
                  textAlign: TextAlign.center,
                );
              } else {
                // If data length is greater than or equal to 5, show only 4 labels (first, last, and two equally spaced)
                int step =
                    (dataLength / 3).round(); // Dynamic step for 4 labels
                if (index == 0 || index == lastIndex || index % step == 0) {
                  String? range;
                  if (areaMap &&
                      chartModel.salesData != null &&
                      index < chartModel.salesData!.length) {
                    range = chartModel.salesData?[index].range;
                  } else if (!areaMap &&
                      chartModel.subscriptionData != null &&
                      index < chartModel.subscriptionData!.length) {
                    range = chartModel.subscriptionData?[index].range;
                  } else if (isDetailScreen &&
                      chartModel.directData != null &&
                      index < (chartModel.directData?.length ?? 0)) {
                    range = chartModel.directData?[index].range;
                  } else {
                    range = "";
                  }

                  return Text(
                    formatRange(range),
                    style: getTextTheme().bodyMedium?.copyWith(fontSize: 10, color: Colors.white),
                    textAlign: TextAlign.center,
                  );
                }
              }

              return Container(); // Hide other labels
            }),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  LineTouchData lineTouchData1() {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipRoundedRadius: 10,
        maxContentWidth: 300,
        tooltipBorder: BorderSide(
          color: Colors.white, // Border color
          width: 0.5, // Thin border
        ),
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // Wider padding
        tooltipMargin: 12,
        // Adds extra margin for spacing
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipColor: (LineBarSpot spot) => AppColors.darkBg2,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          if (touchedSpots.isEmpty) return [];

          // Find the last index for range determination
          int lastIndex = -1;
          for (var spot in touchedSpots) {
            if (spot.spotIndex > lastIndex) {
              lastIndex = spot.spotIndex;
            }
          }

          // Get the range text once
          String range = "N/A";
          if (lastIndex >= 0 && lastIndex < chartModel.ranges.length) {
            range = chartModel.ranges[lastIndex];
          }

          // Create tooltip items with range included in the last one
          List<LineTooltipItem> tooltipItems = touchedSpots.map((spot) {
            Color? color = spot.bar.color; // Get the color of the line
            String? lineName =
                chartModel.dataPoints.keys.elementAtOrNull(spot.barIndex);

            bool isLastSpot = spot == touchedSpots.last;

            return LineTooltipItem(
              '', // Empty main text to use only children
              getTextTheme().bodyMedium!.copyWith(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
              children: [
                TextSpan(
                    text: '$lineName : ', // Label with extra spaces
                    style: getTextTheme().labelMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                TextSpan(
                    text: areaMap
                        ? '\$${spot.y.toStringAsFixed(2)}'
                        : '${spot.y.toInt()}',
                    style: getTextTheme()
                        .labelMedium
                        ?.copyWith(color: color, fontWeight: FontWeight.bold)),
                // Only add the range to the last tooltip item
                if (isLastSpot)
                  TextSpan(
                      text: '\n\n$range',
                      style: getTextTheme().labelLarge?.copyWith(
                          color: AppColors.subText,
                          fontWeight: FontWeight.bold)),
              ],
            );
          }).toList();

          return tooltipItems;
        },
      ),
    );
  }
}

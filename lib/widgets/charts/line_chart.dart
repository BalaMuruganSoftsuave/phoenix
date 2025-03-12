import 'dart:math' as Math ;

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/models/line_chart_model.dart';
import 'dart:core';
import '../../helper/color_helper.dart';
import '../../helper/dependency.dart';
import '../../helper/font_helper.dart';
import '../../helper/responsive_helper.dart';
import '../../helper/utils.dart';

class SalesRevenueChart extends StatelessWidget {
   SalesRevenueChart(
      {super.key, this.areaMap = false, required this.chartModel });

  final bool areaMap;
  final LineChartModel chartModel;
  List<FlSpot> smoothData(List<FlSpot> originalSpots, int windowSize) {
    List<FlSpot> modifiedSpots = List.from(originalSpots);

    // If there are less than 10 spots, add dummy points
    // while (modifiedSpots.length < 10) {
    //   double newX = modifiedSpots.last.x + 1;
    //   double newY = modifiedSpots.last.y; // Maintain trend instead of resetting to zero
    //   modifiedSpots.add(FlSpot(newX, newY));
    // }
    // if (modifiedSpots.length <= windowSize) return modifiedSpots;

    List<FlSpot> smoothedSpots = [];
    for (int i = 0; i < modifiedSpots.length - windowSize + 1; i++) {
      double sumY = 0;
      for (int j = 0; j < windowSize; j++) {
        sumY += modifiedSpots[i + j].y;
      }
      // Choose the center X value in the window instead of offset-based
      double midX = modifiedSpots[i + (windowSize ~/ 2)].x;
      smoothedSpots.add(FlSpot(midX, sumY / windowSize));
    }

    return smoothedSpots;
  }

  @override
  Widget build(BuildContext context) {
    final totalSales = _calculateTotalSales(); // Calculate totals for legend
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
        Center(
          child: areaMap
              ? Wrap(
            alignment: WrapAlignment.start, // Align items from the start
            spacing: 10, // Horizontal spacing between items
            runSpacing: 10, // Vertical spacing between wrapped rowstween wrapped rows
                children: [
                  LegendWidget(
                      color: AppColors.pink,
                      text: 'Direct',
                      amount: totalSales['Direct Sale'] ?? 0),

                  // Vertical Divider
                  Container(
                    width: 1, // Divider thickness
                    height: 60, // Adjust height as needed
                    color: AppColors.lines, // Adjust color as needed
                    margin: EdgeInsets.symmetric(
                        horizontal: 10), // Space around divider
                  ),

                  LegendWidget(
                      color: AppColors.successGreen,
                      text: 'Upsell',
                      amount: totalSales['Upsell Sale'] ?? 0),

                  Container(
                    width: 1,
                    height: 60,
                    color: AppColors.lines,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                  ),

                  LegendWidget(
                      color: AppColors.seaBlue,
                      text: 'Initial',
                      amount: totalSales['Initial Sale'] ?? 0),
                  Container(
                    width: 1,
                    height: 60,
                    color: AppColors.lines,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                  ),

                  LegendWidget(
                      color: AppColors.purple,
                      text: 'Recurring',
                      amount: totalSales['Recurring Sale'] ?? 0),
                  Container(
                    width: 1,
                    height: 60,
                    color: AppColors.lines,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                  ),

                  LegendWidget(
                      color: AppColors.orange,
                      text: 'Salvage',
                      amount: totalSales['Salvage Sale'] ?? 0),



                ],
              )
              : Wrap(
                alignment: WrapAlignment.start, // Align items from the start
                spacing: 10, // Horizontal spacing between items
                runSpacing: 10,
                children: [
                  LegendWidget(
                      color: AppColors.pink,
                      text: 'Net Subscribers',
                      amount: totalSubs['netSubscriptions'] ?? 0),

                  // Vertical Divider
                  Container(
                    width: 1, // Divider thickness
                    height: 60, // Adjust height as needed
                    color: AppColors.lines, // Adjust color as needed
                    margin: EdgeInsets.symmetric(
                        horizontal: 10), // Space around divider
                  ),

                  LegendWidget(
                      color: AppColors.successGreen,
                      text: 'New Subscribers',
                      amount: totalSubs['newSubscriptions'] ?? 0),

                  Container(
                    width: 1,
                    height: 60,
                    color: AppColors.lines,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                  ),

                  LegendWidget(
                      color: AppColors.seaBlue,
                      text: 'Cancelled Subscribers',
                      amount: totalSubs['cancelledSubscriptions'] ?? 0),
                ],
              ),
        )
      ],
    );
  }
   String formatRange(String? range) {
     if (range == null || range.isEmpty) return "";

     List<String> parts = range.split(" ");

     // If there's a time (AM/PM), return only the time
     if (parts.length > 1 && RegExp(r'^\d{1,2}(AM|PM|am|pm)$').hasMatch(parts.last)) {
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

  Map<String, double> _calculateTotalSubscriptions(
      List<SubscriptionData>? subscriptionData) {
    final totals = <String, double>{
      "netSubscriptions": 0,
      "newSubscriptions": 0,
      "cancelledSubscriptions": 0,
    };

    for (var entry in subscriptionData ?? []) {
      totals["netSubscriptions"] =
          (totals["netSubscriptions"] ?? 0) + (entry.netSubscriptions??0);
      totals["newSubscriptions"] =
          (totals["newSubscriptions"] ?? 0) + (entry.newSubscriptions??0);
      totals["cancelledSubscriptions"] =
          (totals["cancelledSubscriptions"] ?? 0) +
             ( entry.cancelledSubscriptions??0);
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
        horizontalInterval: Math.max((maxY - minY) / 2, 1),
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
          return (length * 0.1).round().clamp(1, length ); // 10% of data, min 3
        }
        // List<FlSpot> smoothedSpots =
        //     smoothData(entry.value, calculateWindowSize(entry.value)); // Using window size of 15

        return LineChartBarData(
          preventCurveOverShooting: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              // Show dots only at every 5th point
              return index % 5 == 0
                  ? FlDotCirclePainter(radius: 3, color: Colors.blue)
                  : FlDotCirclePainter(radius: 0, color: Colors.transparent);
            },
          ),
          curveSmoothness: 0.4,
          // spots: normalizeAndReducePoints(entry.value,14,2000,5),
          spots: entry.value,
          isCurved: true,
          color: chartModel.lineColors[entry.key],
          barWidth: 3,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: areaMap,
            gradient: LinearGradient(
              begin: Alignment.topCenter, // Starts from the top
              end: Alignment.bottomCenter, // Fades downwards
              colors: [
                chartModel.lineColors[entry.key]!
                    .withValues(alpha: 1), // Start with some opacity
                // chartModel.lineColors[entry.key]!.withOpacity(0.1), // Fully transparent at the bottom
                Colors.white.withValues(alpha: 0.2)
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

      print(minY);
      minY=(minY > 0)? 0:minY;
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
        return NumberFormat("#,##0").format(value); // Default with commas (e.g., -950 → "-950")
      }
    }

    double interval;
    return FlTitlesData(

      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          maxIncluded: true,
          minIncluded: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            double absMax = Math.max(minY.abs(), maxY.abs()); // Get the larger absolute value
              interval = absMax / 2;

            List<double> valuesToShow = [
              minY,             // Ensure minY is included
              -absMax,          // Most negative value
              -interval,        // Middle negative value
              0,                // Zero
              interval,         // Middle positive value
              maxY              // Most positive value
            ];

            valuesToShow = valuesToShow.map((v) => double.parse(v.toStringAsFixed(1))).toList();

            // Only show our specific values
            if (valuesToShow.contains(value)) {
              return Text(
                formatValue(value),
                style: const TextStyle(fontSize: 10, color: Colors.white),
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
          getTitlesWidget: (value, meta) {
            int index = value.toInt();

            // Get actual data length safely
            int dataLength = areaMap
                ? (chartModel.salesData?.length ?? 0)
                : (chartModel.subscriptionData?.length ?? 0);
            // Subtract 1 safely, ensuring we don't have negative values
            int lastIndex = dataLength > 0 ? dataLength - 1 : 0;

            // Double-check the index is within bounds
            if (index < 0 || index >= dataLength) {
              return Container(); // Return an empty widget if out of bounds
            }

            // Ensure first and last labels are always shown, and show every 3rd label
            if (index == 0 || index == lastIndex || index % 3 == 0) {
              // Only try to access data if we're sure the index is valid
              String? range;
              if (areaMap && chartModel.salesData != null && index < chartModel.salesData!.length) {
                range = chartModel.salesData![index].range;
              } else if (!areaMap && chartModel.subscriptionData != null && index < chartModel.subscriptionData!.length) {
                range = chartModel.subscriptionData![index].range;
              } else {
                range = "";
              }

              formatRange(range);

              return Text(
                formatRange(range),
                style: const TextStyle(fontSize: 10, color: Colors.white),
                textAlign: TextAlign.center,
              );
            }

            return Container(); // Hide other labels
          },
        ),
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
        tooltipPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8), // Wider padding
        tooltipMargin: 12, // Adds extra margin for spacing
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipColor: (LineBarSpot spot) => AppColors.darkBg2,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            Color? color = spot.bar.color; // Get the color of the line
            String? lineName =
                chartModel.dataPoints.keys.elementAtOrNull(spot.barIndex);

            return LineTooltipItem(
              '', // Empty main text to use only children
              TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,

              children: [
                TextSpan(
                  text: '$lineName : ', // Label with extra spaces (thin spaces)
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white, // White label
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      '\$${spot.y.toStringAsFixed(2)}', // Invisible zero-width space
                  style: TextStyle(
                    fontSize: 12,
                    color: color, // Change this to any color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }).toList();
        },
      ),
    );
  }
}

// class LegendWidget extends StatelessWidget {
//   final Color color;
//   final String text;
//   final double amount; // API value
//
//   const LegendWidget({
//     super.key,
//     required this.color,
//     required this.text,
//     required this.amount,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             CircleAvatar(
//               radius: 6, // Small dot
//               backgroundColor: color,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               text, // Revenue, Refund, Void
//               style: getTextTheme().labelSmall?.copyWith(
//                     fontSize: Responsive.fontSize(getCtx()!, 3),
//                     color: AppColors.text,
//                     fontWeight: FontHelper.semiBold,
//                   ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 2),
//         Text(
//           '\$${amount.toStringAsFixed(2)}', // Example: $500
//           style: getTextTheme().labelSmall?.copyWith(
//                 fontSize: Responsive.fontSize(getCtx()!, 3),
//                 color: AppColors.text,
//                 fontWeight: FontHelper.semiBold,
//               ),
//         ),
//       ],
//     );
//   }
// }
class LegendWidget extends StatelessWidget {
  final Color color;
  final String text;
  final double amount;

  const LegendWidget({
    super.key,
    required this.color,
    required this.text,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: Responsive.boxW(context, 40), // Set a reasonable width limit to prevent overflow
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 6, // Small dot
                backgroundColor: color,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  text,
                  style: getTextTheme().labelSmall?.copyWith(
                    fontSize: Responsive.fontSize(getCtx()!, 3),
                    color: AppColors.text,
                    fontWeight: FontHelper.semiBold,
                  ),
                  overflow: TextOverflow.ellipsis, // Prevents overflow
                  softWrap: false, // Ensures it stays on one line
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: getTextTheme().labelSmall?.copyWith(
              fontSize: Responsive.fontSize(getCtx()!, 3),
              color: AppColors.text,
              fontWeight: FontHelper.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}

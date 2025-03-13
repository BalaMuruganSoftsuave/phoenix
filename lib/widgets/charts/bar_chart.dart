import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/helper/responsive_helper.dart';

import '../../helper/color_helper.dart';
import '../../helper/dependency.dart';
import '../../helper/font_helper.dart';
import '../../helper/utils.dart';
import '../../models/bar_chart_model.dart';
import 'legend_widget.dart';

class BarChartWidget extends StatelessWidget {
  final List<ChartData> chartData;
  final double barRadius;
  final double? width;
  final double barSpace;
  final bool showBackDraw;
  final bool showAllRods;
  final bool isLegendRequired;
  final LayerLink _layerLink = LayerLink();

  BarChartWidget({
    super.key,
    this.showBackDraw = false,
    required this.chartData,
    required this.barRadius,
    this.showAllRods = false,
    this.isLegendRequired = true,
    required this.barSpace,
    this.width = 120,
  });

  Widget leftTitles(double value, TitleMeta meta) {
    return Text(
      '${value.toInt()}%', // Display values like 20%, 40%, etc.
      style: getTextTheme().labelSmall?.copyWith(
          fontSize: Responsive.fontSize(getCtx()!, 3),
          color: AppColors.text,
          fontWeight: FontHelper.semiBold),
      textAlign: TextAlign.left,
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= chartData.length) {
      return const SizedBox(); // Prevents out-of-bounds errors
    }
    return SideTitleWidget(
      meta: meta,
      child: FittedBox(
        fit: BoxFit.scaleDown, // Prevents text from overflowing
        child: Text(
          chartData[index].range,
          style: getTextTheme().labelSmall?.copyWith(
              fontSize: Responsive.fontSize(getCtx()!, 3),
              color: AppColors.text,
              fontWeight: FontHelper.semiBold),
        ),
      ),
    );
  }

  Color getColorForLabel(String label) {
    Map<String, Color> colorMap = {
      "Void": voidColor,
      "Revenue": revenueColor,
      "Refund": refundColor,
      "Approved": approved,
      "Declined": revenueColor,
    };
    return colorMap[label] ?? Colors.grey; // Default color if not found
  }

  @override
  Widget build(BuildContext context) {
// Calculate the grand total of all values
    double grandTotal = chartData.fold(
        0, (sum, data) => sum + data.values.values.fold(0, (s, v) => s + v));

// Calculate the total sum for each category
    Map<String, double> totalSums = {};

// Loop through all chartData entries
    for (var data in chartData) {
      data.values.forEach((key, value) {
        totalSums[key] = (totalSums[key] ?? 0) + value;
      });
    }

// Compute total percentage contribution for each category
    Map<String, double> totalPercentages = {
      for (var key in totalSums.keys)
        key: (grandTotal > 0) ? (totalSums[key]! / grandTotal) * 100 : 0,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left

      children: [
        SizedBox(
          height: Responsive.screenH(context, 28),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Enables horizontal scrolling

            child: Container(
              width: chartData.length *
                  (width??120), // Ensures enough space for scrolling
              padding: const EdgeInsets.only(left: 10, right: 10),

              child: CompositedTransformTarget(
                link: _layerLink,
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 40,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: leftTitles,
                          reservedSize: 40, // Ensures enough space for numbers
                          interval: 20, // Show labels at 0, 20, 40, 60, 80, 100
                        ),
                      ),
                      rightTitles: const AxisTitles(),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize:
                              6, // Adds space at the top to prevent clipping
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                        enabled: true,
                        handleBuiltInTouches: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBorder: BorderSide(
                            color: Colors.white, // Border color
                            width: 0.5, // Thin border
                          ),
                          maxContentWidth: Responsive.boxW(context, 50),
                          tooltipRoundedRadius: 10,

                          tooltipPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          // Wider padding
                          tooltipMargin: 12,
                          // Adds extra margin for spacing
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          getTooltipColor: (group) => AppColors.darkBg2,
                          // Background color for tooltip
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            if (groupIndex < 0 ||
                                groupIndex >= chartData.length) return null;

                            ChartData data = chartData[groupIndex];

                            List<TextSpan> textSpans = [];

                            data.values.forEach((label, value) {
                              double percentage = data.percentages[label] ?? 0;

                              Color color = getColorForLabel(label);

                              textSpans.add(
                                TextSpan(
                                  text: '$label: ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                              if(isLegendRequired) {
                                textSpans.add(
                                TextSpan(
                                  text: '\$${value.toStringAsFixed(2)} ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: color,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                                textSpans.add(
                                  TextSpan(
                                    text: '(${percentage.toStringAsFixed(1)}%)\n',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[300],
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                              if(!isLegendRequired) {
                                textSpans.add(
                                  TextSpan(
                                    text: '${percentage.toStringAsFixed(1)}%\n',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: color,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                            });

                            // Get the range for this group index
                            String range = "N/A";
                            if (groupIndex >= 0) {
                              range = data.range;
                            }

                            // Add an extra line break and then the range at the bottom
                            textSpans.add(
                              TextSpan(
                                text: '\n$range',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.subText,
                                    fontWeight: FontWeight.bold),
                              ),
                            );

                            return BarTooltipItem(
                              textAlign: TextAlign.start,
                              '', // Empty title
                              TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              children:
                                  textSpans, // Show all values in a single tooltip
                            );
                          },
                        )),

                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColors.lines,
                          strokeWidth: 1, // Thin but visible
                          dashArray: null, // Ensures solid line (not dotted)
                        );
                      },
                    ),
                    barGroups: chartData.asMap().entries.map((entry) {
                      int index = entry.key;
                      ChartData data = entry.value;

                      List<MapEntry<String, double>> sortedEntries =
                          data.percentages.entries.toList().reversed.toList();

                      return BarChartGroupData(
                        x: index,
                        barsSpace: barSpace,
                        barRods: List.generate(sortedEntries.length, (i) {
                          final entry = sortedEntries[i];
                          bool isBottomBar = (i ==
                              sortedEntries.length -
                                  1); // Bottom-most bar (Revenue)
                          if (showAllRods) {
                            isBottomBar = false;
                          }
                          return BarChartRodData(
                            backDrawRodData: (!isBottomBar &&
                                    showBackDraw) // Apply background only to bottom-most bar
                                ? BackgroundBarChartRodData(
                                    show: true,
                                    toY: 100, // Full bar height for reference
                                    color: Colors.grey.withValues(
                                        alpha: 0.1), // Subtle background
                                  )
                                : BackgroundBarChartRodData(show: false),
                            // Disable for other bars
                            toY: entry.value,
                            // Ensures bars start from the x-axis
                            color: getColorForLabel(entry.key),
                            width: 30,
                            borderRadius: (isBottomBar)
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(0),
                                  )
                                : BorderRadius.only(
                                    topLeft: Radius.circular(barRadius),
                                    topRight: Radius.circular(barRadius),
                                  ), // Keep top bars flat for stacking
                          );
                        }),
                      );
                    }).toList(),

                    // groupsSpace: 50,
                    maxY: 100,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.start,
          // Align items from the start
          spacing: 4,
          // Horizontal spacing between items
          runSpacing: 15,
          // Vertical spacing between wrapped rowstween wrapped rows
          children: [
            for (int i = 0; i < chartData[0].values.keys.length; i++) ...[
              Padding(
                padding:  EdgeInsets.only(right: isLegendRequired==false?10.0:0),
                child: LegendWidget(
                  color: getColorForLabel(chartData[0]
                      .values
                      .keys
                      .elementAt(i)), // Get corresponding color
                  text: chartData[0].values.keys.elementAt(i),
                  subText:isLegendRequired==false?null:
                      '${formatCurrency(chartData.fold<double>(0, (sum, data) => sum + (data.values[chartData[0].values.keys.elementAt(i)] ?? 0)))}/${(totalPercentages[totalPercentages.keys.elementAt(i)] ?? 0).toStringAsFixed(1)}%',
                ),
              ),

              // Add vertical divider except for the last item
              // if (i < chartData[0].values.keys.length - 1)
              //   Container(
              //     width: 1, // Divider thickness
              //     height: 60, // Adjust height as needed
              //     color: AppColors.lines, // Adjust color as needed
              //     margin: EdgeInsets.symmetric(
              //         horizontal: 10), // Space around divider
              //   ),
            ],
          ],
        ),
      ],
    );
  }
}

// class LegendWidget extends StatelessWidget {
//   final Color color;
//   final String text;
//   final double amount; // API value
//   final double percentage; // API percentage
//
//   const LegendWidget({
//     super.key,
//     required this.color,
//     required this.text,
//     required this.amount,
//     required this.percentage,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(
//         maxWidth: Responsive.boxW(context, 40), // Set a reasonable width limit to prevent overflow
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.max,
//
//             children: [
//               CircleAvatar(
//                 radius: 6, // Small dot
//                 backgroundColor: color,
//               ),
//               const SizedBox(width: 5),
//               Flexible(
//                 child: Text(
//                   text, // Revenue, Refund, Void
//                   style: getTextTheme().labelSmall?.copyWith(
//                     fontSize: Responsive.fontSize(getCtx()!, 3),
//                     color: AppColors.text,
//                     fontWeight: FontHelper.semiBold,
//                   ),
//                   overflow: TextOverflow.ellipsis, // Prevents overflow
//                   softWrap: false,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 4),
//           Padding(
//             padding:  EdgeInsets.symmetric(horizontal: Responsive.padding(context, 5)),
//             child: Text(
//               '\$${amount.toStringAsFixed(2)} / ${percentage.toStringAsFixed(1)}%', // Example: $500 / 10%
//               style: getTextTheme().labelSmall?.copyWith(
//                     fontSize: Responsive.fontSize(getCtx()!, 3),
//                     color: AppColors.text,
//                     fontWeight: FontHelper.semiBold,
//                   ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

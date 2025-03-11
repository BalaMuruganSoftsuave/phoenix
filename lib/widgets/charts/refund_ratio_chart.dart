import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/widgets/charts/tool_tip_widget.dart';

import '../../helper/color_helper.dart';
import '../../helper/font_helper.dart';
import '../../helper/utils.dart';
import '../../models/bar_chart_model.dart';

class BarChartWidget extends StatelessWidget {
  final List<ChartData> chartData;
  final double barRadius;
  final double barSpace;
  final String title;
  final bool showBackDraw;

  BarChartWidget(
      {super.key,
        this.showBackDraw=false,
      required this.chartData,
      required this.barRadius,
      required this.barSpace,
      required this.title});
  //
  // BarChartGroupData generateGroupData(
  //     int x, ChartData data, BuildContext context) {
  //   return BarChartGroupData(
  //     x:x,
  //     barsSpace: barSpace,
  //     barRods: [
  //       BarChartRodData(
  //         toY: data.revenuePercentage,
  //         color: revenueColor,
  //         width: Responsive.boxW(context, 9),
  //         borderRadius:  BorderRadius.only(
  //           topLeft: Radius.circular(barRadius),
  //           topRight: Radius.circular(barRadius),
  //         ),
  //       ),
  //       BarChartRodData(
  //         toY: data.refundPercentage,
  //         color: refundColor,
  //         width: Responsive.boxW(context, 9),
  //         borderRadius:  BorderRadius.only(
  //           topLeft: Radius.circular(barRadius),
  //           topRight: Radius.circular(barRadius),
  //         ),
  //       ),
  //       BarChartRodData(
  //         toY: data.voidPercentage,
  //         color: voidColor,
  //         width: Responsive.boxW(context, 9),
  //         borderRadius:  BorderRadius.only(
  //           topLeft: Radius.circular(barRadius),
  //           topRight: Radius.circular(barRadius),
  //         ),
  //       ),
  //
  //     ],
  //   );
  // }

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

  /// ✅ **Hide Tooltip When User Taps Elsewhere**
  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  /// ✅ Show Tooltip When Bar is Tapped
  // void _showTooltip(BuildContext context,BarTouchResponse barTouchResponse, ChartData data) {
  //   _overlayEntry?.remove(); // Remove any existing tooltip
  //   final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //   final Offset chartPosition = renderBox.localToGlobal(Offset.zero); // Chart's global position
  //
  //   final touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
  //
  //   // Get bar position from the chart width
  //   final double chartWidth = renderBox.size.width;
  //   final double barX = chartWidth / chartData.length * (touchedIndex + 0.5); // Center of bar
  //   final double tooltipX = chartPosition.dx + 60; // Adjust for center
  //   final double tooltipY = chartPosition.dy ; // Position above the bar
  //   _overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       left: tooltipX, // Adjust X position
  //       top:tooltipY, // Adjust Y position
  //       child: Material(
  //         color: Colors.transparent,
  //         child: TooltipWidget(data: data),
  //       ),
  //     ),
  //   );
  //
  //   Overlay.of(context).insert(_overlayEntry!);
  // }

  Color getColorForLabel(String label) {
    Map<String, Color> colorMap = {
      "Void": voidColor,
      "Revenue": revenueColor,
      "Refund": refundColor,
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

    return Container(
      padding: EdgeInsets.all(Responsive.padding(context, 3)),
      decoration: BoxDecoration(
          color: AppColors.darkBg2,
          borderRadius: BorderRadius.circular(Responsive.padding(context, 3)),
          border: Border.all(color: AppColors.grey2)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left

        children: [
          Text(
            translate(title),
            textAlign: TextAlign.start, // Ensures text itself aligns left
            style: getTextTheme().titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: Responsive.fontSize(context, 4.8),
                ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SizedBox(
              height: Responsive.screenH(context, 25),
              child: SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal, // Enables horizontal scrolling

                child: Container(
                  width: chartData.length *
                      120, // Ensures enough space for scrolling
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
                              reservedSize:
                                  40, // Ensures enough space for numbers
                              interval:
                                  20, // Show labels at 0, 20, 40, 60, 80, 100
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
                            // touchCallback: (FlTouchEvent event, BarTouchResponse? barTouchResponse) {
                            //   if (event is FlTapDownEvent) {
                            //     _hideTooltip(); // Hide any existing tooltip first
                            //
                            //     if (barTouchResponse?.spot != null) {
                            //       final touchedIndex = barTouchResponse!.spot!.touchedBarGroupIndex;
                            //       if (touchedIndex >= 0 && touchedIndex < chartData.length) {
                            //         _showTooltip(context, barTouchResponse, chartData[touchedIndex] );
                            //       }
                            //     }
                            //   } else if (event is FlTapUpEvent || event is FlLongPressEnd) {
                            //     _hideTooltip(); // Hide tooltip when the finger is lifted
                            //   }
                            // },

                            touchTooltipData: BarTouchTooltipData(
                              // tooltipBgColor: Colors.black87,
                              tooltipBorder: BorderSide(
                                color: Colors.white, // Border color
                                width: 0.5, // Thin border
                              ),
                              maxContentWidth: 500,
                              tooltipRoundedRadius: 10,

                              tooltipPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8), // Wider padding
                              tooltipMargin:
                                  12, // Adds extra margin for spacing
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                              getTooltipColor: (group) => AppColors.darkBg2,
                              // Background color for tooltip
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                if (groupIndex < 0 ||
                                    groupIndex >= chartData.length) return null;

                                ChartData data = chartData[groupIndex];

                                List<TextSpan> textSpans = [];

                                data.values.forEach((label, value) {
                                  double percentage =
                                      data.percentages[label] ?? 0;

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
                                  textSpans.add(
                                    TextSpan(
                                      text: '\$${value.toStringAsFixed(2)}\n',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: color,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                  textSpans.add(
                                    TextSpan(
                                      text:
                                          '(${percentage.toStringAsFixed(1)}%)\n',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[300],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                });

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
                              dashArray:
                                  null, // Ensures solid line (not dotted)
                            );
                          },
                        ),
                        barGroups: chartData.asMap().entries.map((entry) {
                          int index = entry.key;
                          ChartData data = entry.value;

                          List<MapEntry<String, double>> sortedEntries = data.percentages.entries.toList().reversed.toList();

                          return BarChartGroupData(
                            x: index,
                            barsSpace: barSpace,
                            barRods: List.generate(sortedEntries.length, (i) {
                              final entry = sortedEntries[i];
                              bool isBottomBar = (i == sortedEntries.length-1); // Bottom-most bar (Revenue)

                              return BarChartRodData(
                                backDrawRodData:( !isBottomBar && showBackDraw)// Apply background only to bottom-most bar
                                    ? BackgroundBarChartRodData(
                                  show: true,
                                  toY: 100, // Full bar height for reference
                                  color: Colors.grey.withValues(alpha: 0.1), // Subtle background
                                )
                                    : BackgroundBarChartRodData(show: false), // Disable for other bars
                                toY: entry.value, // Ensures bars start from the x-axis
                                color: getColorForLabel(entry.key),
                                width: 30,
                                borderRadius: isBottomBar
                                    ? BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                    topRight: Radius.circular(0),

                              ):BorderRadius.only(
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
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < chartData[0].values.keys.length; i++) ...[
                Expanded(
                  child: LegendWidget(
                    color: getColorForLabel(chartData[0]
                        .values
                        .keys
                        .elementAt(i)), // Get corresponding color
                    text: chartData[0].values.keys.elementAt(i), // Legend text
                    amount: chartData.fold(
                        0,
                        (sum, data) =>
                            sum +
                            (data.values[
                                    chartData[0].values.keys.elementAt(i)] ??
                                0)), // Get total amount dynamically
                    percentage:
                        totalPercentages[totalPercentages.keys.elementAt(i)] ??
                            0, // Use **total percentage** from all data
                  ),
                ),

                // Add vertical divider except for the last item
                if (i < chartData[0].values.keys.length - 1)
                  Container(
                    width: 1, // Divider thickness
                    height: 60, // Adjust height as needed
                    color: AppColors.lines, // Adjust color as needed
                    margin: EdgeInsets.symmetric(
                        horizontal: 10), // Space around divider
                  ),
              ],
            ],
          ),

          // GestureDetector(
          //   onTap: _hideTooltip, // Hide tooltip when user taps elsewhere
          //   behavior: HitTestBehavior.opaque,
          // ),
        ],
      ),
    );
  }
}

class LegendWidget extends StatelessWidget {
  final Color color;
  final String text;
  final double amount; // API value
  final double percentage; // API percentage

  const LegendWidget({
    super.key,
    required this.color,
    required this.text,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 6, // Small dot
          backgroundColor: color,
        ),
        const SizedBox(height: 4),
        Text(
          text, // Revenue, Refund, Void
          style: getTextTheme().labelSmall?.copyWith(
                fontSize: Responsive.fontSize(getCtx()!, 3),
                color: AppColors.text,
                fontWeight: FontHelper.semiBold,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          '\$${amount.toStringAsFixed(2)} / ${percentage.toStringAsFixed(1)}%', // Example: $500 / 10%
          style: getTextTheme().labelSmall?.copyWith(
                fontSize: Responsive.fontSize(getCtx()!, 3),
                color: AppColors.text,
                fontWeight: FontHelper.semiBold,
              ),
        ),
      ],
    );
  }
}

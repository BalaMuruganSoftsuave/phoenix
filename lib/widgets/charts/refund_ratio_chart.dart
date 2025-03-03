import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';

import '../../helper/color_helper.dart';
import '../../helper/font_helper.dart';
import '../../helper/utils.dart';
import '../../models/bar_chart_model.dart';

class BarChartWidget extends StatelessWidget {
  final List<ChartData> chartData;
  final double barRadius;
  final double barSpace;
  final String title;


   const BarChartWidget({super.key, required this.chartData,required this.barRadius, required this.barSpace, required this.title});

  BarChartGroupData generateGroupData(
      int x, ChartData data, BuildContext context) {
    return BarChartGroupData(
      x:x,
      barsSpace: barSpace,
      barRods: [
        BarChartRodData(
          toY: data.revenuePercentage,
          color: revenueColor,
          width: Responsive.boxW(context, 9),
          borderRadius:  BorderRadius.only(
            topLeft: Radius.circular(barRadius),
            topRight: Radius.circular(barRadius),
          ),
        ),
        BarChartRodData(
          toY: data.refundPercentage,
          color: refundColor,
          width: Responsive.boxW(context, 9),
          borderRadius:  BorderRadius.only(
            topLeft: Radius.circular(barRadius),
            topRight: Radius.circular(barRadius),
          ),
        ),
        BarChartRodData(
          toY: data.voidPercentage,
          color: voidColor,
          width: Responsive.boxW(context, 9),
          borderRadius:  BorderRadius.only(
            topLeft: Radius.circular(barRadius),
            topRight: Radius.circular(barRadius),
          ),
        ),

      ],
    );
  }

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

  @override
  Widget build(BuildContext context) {
    double totalRevenue = chartData.fold(0, (sum, item) => sum + item.revenueValue);
    double totalRefund = chartData.fold(0, (sum, item) => sum + item.refundValue);
    double totalVoid = chartData.fold(0, (sum, item) => sum + item.voidValue);

    // Calculate percentages correctly
    double total = totalRevenue + totalRefund + totalVoid;
    double totalPercentageRevenue = (total > 0) ? (totalRevenue / total) * 100 : 0;
    double totalPercentageRefund = (total > 0) ? (totalRefund / total) * 100 : 0;
    double totalPercentageVoid = (total > 0) ? (totalVoid / total) * 100 : 0;

    return Container(

      padding:  EdgeInsets.all(Responsive.padding(context, 3)),
      decoration: BoxDecoration(
        color: AppColors.darkBg2,
          borderRadius: BorderRadius.circular(Responsive.padding(context, 3)),
          border: Border.all(color: AppColors.grey2)
      ),

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
              height: Responsive.screenH(context,25),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enables horizontal scrolling

                child: Container(
                  width:
                      chartData.length * 120, // Ensures enough space for scrolling
                  padding: const EdgeInsets.only(left: 10, right: 10),

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
                          reservedSize: 6, // Adds space at the top to prevent clipping
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        handleBuiltInTouches: true,
                        touchCallback: (FlTouchEvent event, barTouchResponse) {
                          if (event is FlTapUpEvent && barTouchResponse != null) {
                            print("Touched: ${barTouchResponse.spot?.touchedBarGroupIndex}");
                          }
                        },
                        touchTooltipData: BarTouchTooltipData(
                          // tooltipBgColor: Colors.white,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final data = chartData[group.x.toInt()];
                            return BarTooltipItem(
                              '${data.range}\nVoid: ${data.voidValue} (${data.voidPercentage.toStringAsFixed(1)}%)\n'
                                  'Revenue: ${data.revenueValue} (${data.revenuePercentage.toStringAsFixed(1)}%)\n'
                                  'Refund: ${data.refundValue} (${data.refundPercentage.toStringAsFixed(1)}%)',
                              const TextStyle(color: Colors.black, fontSize: 10),
                            );
                          },
                        ),
                      ),

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
                      barGroups: List.generate(
                        chartData.length,
                        (index) =>
                            generateGroupData(index, chartData[index], context),
                      ),
                      // groupsSpace: 50,
                      maxY: 100,
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
              LegendWidget(color: voidColor, text: 'Void', amount: totalVoid, percentage: totalPercentageVoid),

              // Vertical Divider
              Container(
                width: 1, // Divider thickness
                height: 60, // Adjust height as needed
                color: AppColors.lines, // Adjust color as needed
                margin: EdgeInsets.symmetric(horizontal: 10), // Space around divider
              ),

              LegendWidget(color: revenueColor, text: 'Revenue', amount: totalRevenue, percentage: totalPercentageRevenue),

              Container(
                width: 1,
                height: 60,
                color: AppColors.lines,
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),

              LegendWidget(color: refundColor, text: 'Refund', amount: totalRefund, percentage: totalPercentageRefund),
            ],
          ),

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

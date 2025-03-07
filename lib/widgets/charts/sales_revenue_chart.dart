import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/models/line_chart_model.dart';

import '../../helper/color_helper.dart';
import '../../helper/font_helper.dart';
import '../../helper/responsive_helper.dart';
import '../../helper/utils.dart';


class SalesRevenueChart extends StatelessWidget {
  const  SalesRevenueChart({super.key, this.areaMap = false, required this.chartModel, this.title});

  final bool areaMap;
  final LineChartModel chartModel;
  final title;


  @override
  Widget build(BuildContext context) {
    final totalSales = _calculateTotalSales(); // Calculate totals for legend

    return Container(

      padding:  EdgeInsets.all(Responsive.padding(context, 3)),
      decoration: BoxDecoration(
          color: AppColors.darkBg2,
          borderRadius: BorderRadius.circular(Responsive.padding(context, 3)),
          border: Border.all(color: AppColors.grey2)
      ),

      child: Column(
      mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(
            height: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: chartModel.salesData.length * 50, // Adjust width dynamically
                padding: const EdgeInsets.all(16.0),
                child: LineChart(
                  sampleData1(),
                  duration: const Duration(milliseconds: 250),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LegendWidget(color: AppColors.pink, text: 'Direct Sale', amount: totalSales['Direct Sale']??0),

                // Vertical Divider
                Container(
                  width: 1, // Divider thickness
                  height: 60, // Adjust height as needed
                  color: AppColors.lines, // Adjust color as needed
                  margin: EdgeInsets.symmetric(horizontal: 10), // Space around divider
                ),

                LegendWidget(color: AppColors.successGreen, text: 'Upsell Sale', amount: totalSales['Upsell Sale']??0),

                Container(
                  width: 1,
                  height: 60,
                  color: AppColors.lines,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                ),

                LegendWidget(color: AppColors.successGreen, text: 'Upsell Sale', amount: totalSales['Upsell Sale']??0),
                Container(
                  width: 1,
                  height: 60,
                  color: AppColors.lines,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                ),

                LegendWidget(color: AppColors.successGreen, text: 'Upsell Sale', amount: totalSales['Upsell Sale']??0),
                Container(
                  width: 1,
                  height: 60,
                  color: AppColors.lines,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                ),

                LegendWidget(color: AppColors.successGreen, text: 'Upsell Sale', amount: totalSales['Upsell Sale']??0),
                Container(
                  width: 1,
                  height: 60,
                  color: AppColors.lines,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                ),

                LegendWidget(color: AppColors.successGreen, text: 'Upsell Sale', amount: totalSales['Upsell Sale']??0),
              ],
            ),
          ),
        ],
      ),
    );
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

    for (var entry in chartModel.salesData) {
      totals["Direct Sale"] = (totals["Direct Sale"] ?? 0) + (entry.directSale??0);
      totals["Upsell Sale"] = (totals["Upsell Sale"] ?? 0) + (entry.upsellSale??0);
      totals["Initial Sale"] = (totals["Initial Sale"] ?? 0) + (entry.initialSale??0);
      totals["Recurring Sale"] = (totals["Recurring Sale"] ?? 0) + (entry.recurringSale??0);
      totals["Salvage Sale"] = (totals["Salvage Sale"] ?? 0) + (entry.salvageSale??0);
    }

    return totals;
  }
  LineChartData sampleData1() {
    return LineChartData(
      // minX: 0,
      // maxX: chartModel.salesData.length.toDouble(),  // Adjust X scale dynamically
      // minY: 100,
      // maxY: 10, // Adjust Y s  cale according to your data range
      lineTouchData: lineTouchData1(),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        horizontalInterval: 1000,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.lines,
            strokeWidth: 1, // Thin but visible
            dashArray: null, // Ensures solid line (not dotted)
          );
        },
      ),
      titlesData: getTitlesData(),

      borderData: FlBorderData(
        show: false,
        border: const Border(
          left: BorderSide(color: Colors.white, width: 1),
          bottom: BorderSide(color: Colors.white, width: 1),
        ),
      ),
      lineBarsData: chartModel.dataPoints.entries.map((entry) {
        return LineChartBarData(

          dotData: FlDotData(show: false),
          curveSmoothness: 0.4,
          spots: entry.value,
          isCurved: true,
          color: chartModel.lineColors[entry.key],
          barWidth: 3,
          isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: areaMap,
              gradient: LinearGradient(
                begin: Alignment.topCenter,  // Starts from the top
                end: Alignment.bottomCenter, // Fades downwards
                colors: [
                  chartModel.lineColors[entry.key]!.withValues(alpha: 1), // Start with some opacity
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

  FlTitlesData getTitlesData() {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            // Convert values to 'k' format (e.g., 1000 -> 1k)
            String formattedValue = '${(value / 1000).toInt()}k';
            return Text(formattedValue, style: const TextStyle(fontSize: 8, color: Colors.white));
          },
          interval: 2000, // Adjusted interval to 1000 for proper 'k' scaling
        ),
      ),

      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            if (index >= 0 && index < chartModel.salesData.length && index % 3 == 0) {
              String timeOnly = chartModel.salesData[index].range.split(" ")[1]; // Extract time
              return Text(
                timeOnly, // Show only time (e.g., "12AM")
                style: const TextStyle(fontSize: 10, color: Colors.white),
              );
            }
            return const SizedBox.shrink();
          },
          interval: 3, // Show titles at every 3rd interval
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
        maxContentWidth: 500,
        tooltipBorder: BorderSide(
          color: Colors.white, // Border color
          width: 0.5, // Thin border
        ),
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Wider padding
        tooltipMargin: 12, // Adds extra margin for spacing
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipColor: (LineBarSpot spot) => AppColors.darkBg2,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {

            Color? color = spot.bar.color; // Get the color of the line
            String? lineName = chartModel.dataPoints.keys.elementAtOrNull(spot.barIndex);

            return LineTooltipItem(
               '',// Empty main text to use only children
               TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
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
                  text: '\$${spot.y.toStringAsFixed(2)}', // Invisible zero-width space
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
class LegendWidget extends StatelessWidget {
  final Color color;
  final String text;
  final double amount; // API value

  const LegendWidget({
    super.key,
    required this.color,
    required this.text,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        Row(
          children: [
            CircleAvatar(
              radius: 6, // Small dot
              backgroundColor: color,
            ),
            const SizedBox(width: 4),
            Text(
              text, // Revenue, Refund, Void
              style: getTextTheme().labelSmall?.copyWith(
                fontSize: Responsive.fontSize(getCtx()!, 3),
                color: AppColors.text,
                fontWeight: FontHelper.semiBold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '\$${amount.toStringAsFixed(2)}', // Example: $500
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

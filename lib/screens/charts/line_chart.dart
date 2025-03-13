// import 'dart:math' as Math;
//
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// import '../../helper/color_helper.dart';
//
// class SalesRevenueChart extends StatelessWidget {
//   final bool areaMap;
//   final ChartModel chartModel;
//
//   const SalesRevenueChart({
//     super.key,
//     this.areaMap = false,
//     required this.chartModel,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Chart
//         SizedBox(
//           height: 250,
//           child: Container(
//             width: Math.max(
//               MediaQuery.of(context).size.width,
//               (chartModel.dataPoints.entries.first.value.length * 50).toDouble(),
//             ),
//             padding: const EdgeInsets.all(16.0),
//             child: LineChart(
//               sampleData(),
//               duration: const Duration(milliseconds: 250),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//
//         // Legend
//         Center(
//           child: Wrap(
//             alignment: WrapAlignment.start,
//             spacing: 10,
//             runSpacing: 10,
//             children: chartModel.legendData.map((data) {
//               return LegendWidget(
//                 color: data.color,
//                 text: data.label,
//                 amount: data.value,
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Build chart data
//   LineChartData sampleData() {
//     List<FlSpot> spots = [];
//     double minY = 0;
//     double maxY = 0;
//
//     for (var entry in chartModel.dataPoints.entries) {
//       spots.addAll(entry.value.map((spot) => FlSpot(spot.x, spot.y)));
//     }
//
//     if (spots.isNotEmpty) {
//       minY = spots.map((spot) => spot.y).reduce(Math.min);
//       maxY = spots.map((spot) => spot.y).reduce(Math.max);
//
//       maxY = (maxY * 1.1).ceilToDouble(); // Add padding at the top
//     }
// return  LineChartData(
//   minY: minY,
//   maxY: maxY,
//   lineTouchData: lineTouchData1(),
//   gridData: FlGridData(
//     show: true,
//     drawHorizontalLine: true,
//     drawVerticalLine: false,
//     horizontalInterval: Math.max((maxY - minY) / 2, 1),
//     getDrawingHorizontalLine: (value) {
//       return FlLine(
//         color: AppColors.lines,
//         strokeWidth: 1, // Thin but visible
//         dashArray: null, // Ensures solid line (not dotted)
//       );
//     },
//   ),
//   titlesData: getTitlesData(spots),
//   borderData: FlBorderData(
//     show: false,
//     border: const Border(
//       left: BorderSide(color: Colors.white, width: 1),
//       bottom: BorderSide(color: Colors.white, width: 1),
//     ),
//   ),
//   lineBarsData: chartModel.dataPoints.entries.map((entry) {
//     int calculateWindowSize(List<FlSpot> spots) {
//       int length = spots.length;
//
//       // if (length < 10) return 3; // Minimum window size
//       return (length * 0.1).round().clamp(1, length ); // 10% of data, min 3
//     }
//     // List<FlSpot> smoothedSpots =
//     //     smoothData(entry.value, calculateWindowSize(entry.value)); // Using window size of 15
//
//     return LineChartBarData(
//       preventCurveOverShooting: true,
//       dotData: FlDotData(
//         show: true,
//         getDotPainter: (spot, percent, barData, index) {
//           // Show dots only at every 5th point
//           return index % 5 == 0
//               ? FlDotCirclePainter(radius: 3, color: Colors.blue)
//               : FlDotCirclePainter(radius: 0, color: Colors.transparent);
//         },
//       ),
//       curveSmoothness: 0.4,
//       // spots: normalizeAndReducePoints(entry.value,14,2000,5),
//       spots: entry.value,
//       isCurved: true,
//       color: chartModel.lineColors[entry.key],
//       barWidth: 3,
//       isStrokeCapRound: true,
//       belowBarData: BarAreaData(
//         show: areaMap,
//         gradient: LinearGradient(
//           begin: Alignment.topCenter, // Starts from the top
//           end: Alignment.bottomCenter, // Fades downwards
//           colors: [
//             chartModel.lineColors[entry.key]!
//                 .withValues(alpha: 1), // Start with some opacity
//             // chartModel.lineColors[entry.key]!.withOpacity(0.1), // Fully transparent at the bottom
//             Colors.white.withValues(alpha: 0.2)
//           ],
//         ),
//       ),
//     );
//   }).toList(),
// )
//     return LineChartData(
//       minY: minY,
//       maxY: maxY,
//       lineTouchData: lineTouchData(),
//       gridData: FlGridData(
//         show: true,
//         drawHorizontalLine: true,
//         drawVerticalLine: false,
//         horizontalInterval: Math.max((maxY - minY) / 2, 1),
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: AppColors.lines,
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: getTitlesData(spots),
//       borderData: FlBorderData(show: false),
//       lineBarsData: chartModel.dataPoints.entries.map((entry) {
//         var spots=entry.value.map((e)=>FlSpot(e.x, e.y)).toList();
//         return LineChartBarData(
//           preventCurveOverShooting: false,
//           spots: spots,
//           isCurved: true,
//           curveSmoothness: 0.4,
//
//           color: chartModel.legendData
//               .firstWhere((e) => e.label == entry.key)
//               .color,
//           barWidth: 3,
//           isStrokeCapRound: true,
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 chartModel.legendData
//                     .firstWhere((e) => e.label == entry.key)
//                     .color
//                     .withValues(alpha: 0.5),
//                 Colors.white.withValues(alpha: 0.1)
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   /// Chart titles
//   FlTitlesData getTitlesData(List<FlSpot> spots) {
//     double minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
//     double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
//
//     minY = minY > 0 ? 0 : minY;
//     maxY = (maxY * 1.1).ceilToDouble();
//
//     return FlTitlesData(
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 30,
//           getTitlesWidget: (value, meta) {
//             if (value == minY || value == maxY) {
//               return Text(
//                 value.toStringAsFixed(1),
//                 style: const TextStyle(fontSize: 10, color: Colors.white),
//               );
//             }
//             return Container();
//           },
//         ),
//       ),
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 20,
//           getTitlesWidget: (value, meta) {
//             int index = value.toInt();
//
//             if (index >= 0 &&
//                 index < chartModel.dataPoints.entries.first.value.length) {
//               return Text(
//                 index.toString(),
//                 style: const TextStyle(fontSize: 10, color: Colors.white),
//                 textAlign: TextAlign.center,
//               );
//             }
//             return Container();
//           },
//         ),
//       ),
//       topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//       rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//     );
//   }
//
//   /// Line touch data
//     LineTouchData lineTouchData1() {
//        return LineTouchData(
//          handleBuiltInTouches: true,
//          touchTooltipData: LineTouchTooltipData(
//            tooltipRoundedRadius: 10,
//            maxContentWidth: 300,
//            tooltipBorder: BorderSide(
//              color: Colors.white, // Border color
//              width: 0.5, // Thin border
//            ),
//            tooltipPadding: const EdgeInsets.symmetric(
//                horizontal: 16, vertical: 8), // Wider padding
//            tooltipMargin: 12, // Adds extra margin for spacing
//            fitInsideHorizontally: true,
//            fitInsideVertically: true,
//            getTooltipColor: (LineBarSpot spot) => AppColors.darkBg2,
//            getTooltipItems: (List<LineBarSpot> touchedSpots) {
//              if (touchedSpots.isEmpty) return [];
//
//              // Find the last index for range determination
//              int lastIndex = -1;
//              for (var spot in touchedSpots) {
//                if (spot.spotIndex > lastIndex) {
//                  lastIndex = spot.spotIndex;
//                }
//              }
//
//              // Get the range text once
//              String range = "N/A";
//              if (lastIndex >= 0 && lastIndex < chartModel.dataPoints.length) {
//                range = chartModel.dataPoints[lastIndex];
//              }
//
//              // Create tooltip items with range included in the last one
//              List<LineTooltipItem> tooltipItems = touchedSpots.map((spot) {
//                Color? color = spot.bar.color; // Get the color of the line
//                String? lineName =
//                chartModel.dataPoints.keys.elementAtOrNull(spot.barIndex);
//
//                bool isLastSpot = spot == touchedSpots.last;
//
//                return LineTooltipItem(
//                  '', // Empty main text to use only children
//                  TextStyle(
//                      fontSize: 12,
//                      color: Colors.white,
//                      fontWeight: FontWeight.bold),
//                  textAlign: TextAlign.start,
//                  children: [
//                    TextSpan(
//                      text: '$lineName : ', // Label with extra spaces
//                      style: const TextStyle(
//                        fontSize: 12,
//                        color: Colors.white, // White label
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                    TextSpan(
//                      text: '\$${spot.y.toStringAsFixed(2)}',
//                      style: TextStyle(
//                        fontSize: 12,
//                        color: color, // Color from the line
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                    // Only add the range to the last tooltip item
//                    if (isLastSpot)
//                      TextSpan(
//                        text: '\n\n$range',
//                        style: const TextStyle(
//                          fontSize: 14,
//                          color: AppColors.subText,
//                          fontWeight: FontWeight.bold,
//                        ),
//                      ),
//                  ],
//                );
//              }).toList();
//
//              return tooltipItems;
//            },
//          ),
//        );
//      }
//   LineTouchData lineTouchData() {
//     return LineTouchData(
//       handleBuiltInTouches: true,
//       touchTooltipData: LineTouchTooltipData(
//         // tooltipBgColor: Colors.black,
//         getTooltipItems: (touchedSpots) {
//           return touchedSpots.map((spot) {
//             String label =
//             chartModel.dataPoints.keys.elementAt(spot.barIndex);
//
//             return LineTooltipItem(
//               '$label: ${spot.y.toStringAsFixed(2)}',
//               const TextStyle(color: Colors.white, fontSize: 12),
//             );
//           }).toList();
//         },
//       ),
//     );
//   }
// }
//
// class LegendWidget extends StatelessWidget {
//   final Color color;
//   final String text;
//   final double amount;
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
//       children: [
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircleAvatar(radius: 6, backgroundColor: color),
//             const SizedBox(width: 4),
//             Text(
//               text,
//               style: TextStyle(fontSize: 12, color: Colors.white),
//             ),
//           ],
//         ),
//         const SizedBox(height: 2),
//         Text(
//           '\$${amount.toStringAsFixed(2)}',
//           style: const TextStyle(fontSize: 12, color: Colors.white),
//         ),
//       ],
//     );
//   }
// }
// class ChartData {
//   final String label;
//   final double value;
//   final Color color;
//
//   ChartData({
//     required this.label,
//     required this.value,
//     required this.color,
//   });
// }
//
// class ChartPoint {
//   final double x;
//   final double y;
//
//   ChartPoint({
//     required this.x,
//     required this.y,
//   });
// }
//
// class ChartModel {
//   final Map<String, List<ChartPoint>> dataPoints;
//   final List<ChartData> legendData;
//
//   ChartModel({
//     required this.dataPoints,
//     required this.legendData,
//   });
// }

import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';

import '../../models/bar_chart_model.dart';

class TooltipWidget extends StatelessWidget {
  final ChartData data;

  const TooltipWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.darkBg2,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(data.range, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: )),
          const SizedBox(height: 8),
          _buildTooltipRow("Revenue", data.revenueValue, data.revenuePercentage, revenueColor),
          const SizedBox(height: 8),

          _buildTooltipRow("Void", data.voidValue, data.voidPercentage,voidColor),
          const SizedBox(height: 8),

          _buildTooltipRow("Refund", data.refundValue, data.refundPercentage, refundColor),
          const SizedBox(height: 8),

        ],
      ),
    );
  }

  Widget _buildTooltipRow(String label, num value, num percentage, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 8),
        RichText(
          textAlign: TextAlign.justify, // Justifies text alignment

          text: TextSpan(
            children: [
              TextSpan(
                text: "$label: ", // Keep label in white
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white, // White label
                  fontWeight: FontWeight.bold,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: SizedBox(width: 10), // Add spacing between label & value
              ),
              TextSpan(
                text: "$value ", // Value in a different color
                style: TextStyle(
                  fontSize: 12,
                  color: color, // Change this to any color
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "(${percentage.toStringAsFixed(1)}%)", // Percentage in default style
                style:  TextStyle(
                  fontSize: 12,
                  color: color, // Light grey for percentage
                ),
              ),
            ],
          ),
        )

      ],
    );
  }
}

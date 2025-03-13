import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/font_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/widgets/gap/widgets/gap.dart';

class LegendWidget extends StatelessWidget {
  final Color color;
  final String text;
  final String? subText;


  const LegendWidget({
    super.key,
    required this.color,
    required this.text,
     this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,

      children: [
        CircleAvatar(
          radius: 6, // Small dot
          backgroundColor: color,
        ),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text, // Revenue, Refund, Void
              style: getTextTheme().labelSmall?.copyWith(
                fontSize: Responsive.fontSize(getCtx()!, 3),
                color: AppColors.text,
                fontWeight: FontHelper.semiBold,
              ),
            ),
            if(subText!=null)...[Gap(8),
              Text(
                subText??"", // Example: $500
                style: getTextTheme().labelSmall?.copyWith(
                  fontSize: Responsive.fontSize(getCtx()!, 3),
                  color: AppColors.white,
                  fontWeight: FontHelper.semiBold,
                ),
              ),],

          ],
        ),
      ],
    );
  }
}
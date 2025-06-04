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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: CircleAvatar(
            radius: 6,
            backgroundColor: color,
          ),
        ),
        SizedBox(width: 8),
        Expanded( // So subText can wrap inside column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: getTextTheme().labelSmall?.copyWith(
                  fontSize: Responsive.fontSize(getCtx()!, 3),
                  color: AppColors.text,
                  fontWeight: FontHelper.semiBold,
                ),
              ),
              if (subText != null && subText!.isNotEmpty) ...[
                Gap(8),
                Text(
                  subText!,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: getTextTheme().labelSmall?.copyWith(
                    fontSize: Responsive.fontSize(getCtx()!, 3),
                    color: AppColors.white,
                    fontWeight: FontHelper.semiBold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

  }
}

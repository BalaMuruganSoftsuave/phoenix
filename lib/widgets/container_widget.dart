import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/utils.dart';

class ContainerWidget extends StatelessWidget {
  final Widget? subTitle;
  final Widget widget;
  final Widget? childWidget;
  final String? title;
  final double? height;
  const ContainerWidget({
    super.key,
    this.subTitle,
    required this.widget,
    this.childWidget,
    this.title, this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.padding(context, 3)),
      decoration: BoxDecoration(
        color: AppColors.darkBg2,
        borderRadius: BorderRadius.circular(Responsive.padding(context, 3)),
        border: Border.all(color: AppColors.grey2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
        children: [
          // Title Row with Right-Aligned Child Widget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  translate(title ?? ""),
                  style: getTextTheme().titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: Responsive.fontSize(context, 4),
                  ),
                ),
              ),
              if (childWidget != null) childWidget!,
            ],
          ),
          SizedBox(height: Responsive.padding(context, 2)), // Spacing

          if (subTitle != null )
           subTitle??Container(),
          SizedBox(height: Responsive.padding(context, 5)), // Spacing

          // Main Content Widget
          widget,

          SizedBox(height: Responsive.padding(context, 2)), // Spacing

          // Subtitle Text (If Available)

        ],
      ),
    );
  }
}

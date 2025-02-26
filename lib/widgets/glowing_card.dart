import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/font_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/utils.dart';

class GlowingCard extends StatelessWidget {
  final String svgAsset;
  final String title;
  final String subtitle;
  final Color circleBgColor;
  final bool isLoading;
  final VoidCallback? onPress;

  const GlowingCard({
    super.key,
    required this.svgAsset,
    required this.title,
    required this.subtitle,
    required this.circleBgColor,
    this.isLoading = false,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    bool isDisabled = isLoading || onPress == null;

    return GestureDetector(
      onTap: isDisabled ? null : onPress,
      child: Container(
        padding:  EdgeInsets.all(Responsive.padding(context, 4),),
        decoration: BoxDecoration(
          color: const Color(0xFF141E2D), // Background color
          borderRadius: BorderRadius.circular(Responsive.padding(context, 7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Circle with Glow Effect
            Container(
              width:Responsive.boxW(context, 12),
              height: Responsive.boxW(context, 12),
              decoration: BoxDecoration(
                color: circleBgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: circleBgColor.withValues(alpha: 0.8),
                    blurRadius: 15,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgAsset,
                  width:Responsive.boxW(context, 8),
                  height: Responsive.boxW(context, 8),
                ),
              ),
            ),
             SizedBox(width: Responsive.boxW(context, 4),),

            // Text Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      title,
                      style: getTextTheme().bodyMedium?.copyWith(fontSize: Responsive.fontSize(context, 4),color: AppColors.subText,fontWeight: FontHelper.semiBold)
                  ),
                  Text(
                      subtitle,
                      style: getTextTheme().bodyMedium?.copyWith(fontSize: Responsive.fontSize(context, 5),color: AppColors.white,fontWeight: FontHelper.semiBold)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

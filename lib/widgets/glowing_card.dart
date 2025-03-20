import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/font_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/widgets/gap/widgets/gap.dart';
import 'package:phoenix/widgets/shimmer.dart';

class GlowingCard extends StatelessWidget {
  final String svgAsset;
  final String title;
  final String subtitle;
  final Color circleBgColor;
  final bool isLoading;
  final VoidCallback? onPress;
  final bool isGlowing;
  final double? imageHeight;
  final double? imageWidth;

  const GlowingCard({
    super.key,
    required this.svgAsset,
    required this.title,
    required this.subtitle,
    required this.circleBgColor,
    this.isLoading = false,
    this.onPress, required this.isGlowing, this.imageHeight, this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    bool isDisabled = isLoading || onPress == null;

    return GestureDetector(
      onTap: isDisabled ? null : onPress,
      child: Container(
        padding: EdgeInsets.all(
          Responsive.padding(context, 4),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF141E2D), // Background color
          borderRadius: BorderRadius.circular(Responsive.padding(context, 5)),
          boxShadow: [
           BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(

          children: [
            // Circle with Glow Effect
            Container(
              width: Responsive.boxW(context, 12),
              height: Responsive.boxW(context, 12),
              decoration: BoxDecoration(
                color: circleBgColor,
                shape: BoxShape.circle,
                boxShadow: isGlowing? [
                  BoxShadow(
                    color: circleBgColor.withValues(alpha: 0.8),
                    blurRadius: 15,
                    offset: const Offset(2, 2),
                  ),
                ]: [],
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgAsset,
                  width: Responsive.boxW(context, imageWidth??7),
                  height: Responsive.boxW(context, imageHeight??7),
                ),
              ),
            ),
            SizedBox(
              width: Responsive.boxW(context, 4),
            ),

            // Text Column
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoading
                      ? ShimmerWidget(
                          height: Responsive.boxH(context, 3),
                          width: Responsive.boxW(context, 30))
                      : Text(translate(title),
                          style: getTextTheme().bodyMedium?.copyWith(
                              fontSize: Responsive.fontSize(context, 3.5),
                              color: AppColors.subText,
                              fontWeight: FontHelper.semiBold)),
                  Gap(
                Responsive.boxW(context,2),
                  ),
                  isLoading
                      ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ShimmerWidget(
                            height: Responsive.boxH(context, 3),
                            width: Responsive.boxW(context, 60)),
                      )
                      : Text(subtitle,
                          style: getTextTheme().bodyMedium?.copyWith(
                              fontSize: Responsive.fontSize(context, 4),
                              color: AppColors.white,
                              fontWeight: FontHelper.semiBold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/utils.dart';

import 'glowing_card.dart';

class CardData {
  final Color circleBgColor;
  final String title;
  final String subtitle;
  final String image;
  final bool isLoading;
  final VoidCallback? onPress;
  final bool? isGlowing;
  final double? imageHeight;
  final double? imageWidth;

  CardData({
    required this.circleBgColor,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.isLoading,
    this.onPress,
    this.imageHeight,
    this.imageWidth,
    this.isGlowing = true
  });
}

class RenderSection extends StatelessWidget {
  final String title;
  final List<CardData> cards;

  const RenderSection({super.key, required this.title, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(Responsive.padding(context, 3)),
      decoration: title.isNotEmpty?BoxDecoration(
        borderRadius: BorderRadius.circular(Responsive.padding(context, 3)),
        border: Border.all(color: AppColors.grey2)
      ):null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: getTextTheme().bodyMedium?.copyWith(color: Colors.white,fontSize: Responsive.fontSize(context, 3)),
            ),
          const SizedBox(height: 10),
          ListView.builder(
            itemCount: cards.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
            itemBuilder: (context, index) {
              final card = cards[index];
              return Column(
                children: [
                  GlowingCard(
                    circleBgColor: card.circleBgColor,
                    title: card.title,
                    subtitle: card.subtitle,
                    svgAsset: card.image,
                    isLoading: card.isLoading,
                    onPress: card.onPress,
                    imageHeight: card.imageHeight,
                    imageWidth: card.imageWidth,
                    isGlowing: card.isGlowing!
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

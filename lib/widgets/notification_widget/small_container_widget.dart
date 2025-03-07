import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';

class SmallContainerWidget extends StatefulWidget {
  final String text1;
  final String text2;
  const SmallContainerWidget({super.key, required this.text1, required this.text2});

  @override
  State<SmallContainerWidget> createState() => _SmallContainerWidgetState();
}

class _SmallContainerWidgetState extends State<SmallContainerWidget> {
  @override
  Widget build(BuildContext context) {

      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          border: Border.all(color: AppColors.borderColor, width: 0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.text1, style: TextStyle(color: AppColors.subText, fontSize: 13)),
            Text(
              widget.text2,
              style: TextStyle(
                  color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  }
}


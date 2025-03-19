import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/utils.dart';

class RadioButtonWidget extends StatelessWidget {
  final int value;
  final String text;
  final int selectedValue;
  final Function(int?)? onChanged;

  const RadioButtonWidget({super.key, required this.value, required this.text, required this.selectedValue, this.onChanged, });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<int>(
      title: Text(text, style: getTextTheme().bodyMedium?.copyWith(color: AppColors.white)),
      value: value,
      groupValue: selectedValue,
      activeColor: AppColors.pink,
      onChanged: onChanged,
    );
  }
}

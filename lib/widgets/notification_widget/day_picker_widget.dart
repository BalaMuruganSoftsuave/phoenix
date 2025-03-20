import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/utils.dart';


class DayPickerWidget extends StatelessWidget {
  final String selectedDay;
  final Function(String) onDaySelected;

   DayPickerWidget({
    super.key,
    required this.onDaySelected,
     required this.selectedDay,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Wrap(
        spacing: 20,
        runSpacing: 5,
        children: weekDays.map((day) {
          bool isSelected = selectedDay == day.id;

          return GestureDetector(
            onTap: () => onDaySelected(day.id??""),
            child: Chip(
              label: Text(day.name??"",
              textAlign: TextAlign.center,
              style: getTextTheme().bodyMedium?.copyWith(
                color: isSelected ? Colors.white : AppColors.text,
                fontWeight: FontWeight.bold,
              ),
                          ),
              backgroundColor: isSelected ? AppColors.pink : AppColors.backgroundGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: isSelected ? BorderSide(color: AppColors.pink) : BorderSide(color: AppColors.borderColor),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

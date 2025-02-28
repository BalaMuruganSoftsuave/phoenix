import 'package:flutter/material.dart';


import 'calender_widget_modal.dart';

class SingleDayWidget extends StatelessWidget {
  const SingleDayWidget({
    super.key,
    required this.select,
    required this.onChange,
    this.isEnabled = true,
    this.isReadonly = true,
    required this.date,
    required this.fontSize, this.currentMonthDateColor, this.otherMonthDateColor, this.startEndColor, this.inBetweenColor, this.selectedDateColor, this.labelTextStyle,
  });

  final ValueNotifier<Selection> select;
  final SelectionChange onChange;
  final bool isEnabled;
  final bool isReadonly;
  final Date date;
  final double fontSize;
  final Color? currentMonthDateColor;
  final Color? otherMonthDateColor;
  final Color? startEndColor;
  final Color? inBetweenColor;
  final Color? selectedDateColor;
  final TextStyle? labelTextStyle;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final bool isToday = (date.day.day == now.day &&
        date.day.month == now.month &&
        date.day.year == now.year);
    final bool isFirst =
        select.value.start != null && date.day.isSameDay(select.value.start!);
    final bool isLast = select.value.isMultiple
        ? select.value.end != null && date.day.isSameDay(select.value.end!)
        : isFirst;
    final end = isFirst || isLast;
    return InkWell(
      onTap: isReadonly || !isEnabled
          ? null
          : () {
              select.value = select.value.clicked(date.day);
              onChange(select.value);
            },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isFirst ? 15 : 0),
                bottomLeft: Radius.circular(isFirst ? 15 : 0),
                topRight: Radius.circular(isLast ? 15 : 0),
                bottomRight: Radius.circular(isLast ? 15 : 0)),
            color: end
                ?startEndColor
                : date.isSelected
                    ? inBetweenColor
                    : Colors.transparent),
        child: Center(
            child:
            Text(date.day.day.toString(),
                textAlign: TextAlign.center,
                style: labelTextStyle ?.copyWith(
                  color: end ? selectedDateColor:!isEnabled?Colors.grey
                          : date.isCurrentMonth
                              ? currentMonthDateColor//current month dates
                              : otherMonthDateColor, //other month dates
                  fontSize: fontSize,
                  fontWeight: isToday
                      ? FontWeight.w700
                      : isEnabled
                          ? FontWeight.w600
                          : FontWeight.w400,
                ))),
      ),
    );
  }
}

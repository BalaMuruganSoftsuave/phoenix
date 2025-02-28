import 'package:flutter/material.dart';

import 'number_picker.dart';

class MonthYearSelectionWidget extends StatefulWidget {
  final DateTime date;
  final Function(int month, int year) onChange;
  final Function(int month, int year) onDone;
  final DateTime? allowedStartDate;
  final DateTime? allowedEndDate;
  final VoidCallback onCancel;
  final Color? cancelColor;
  final Color? doneColor;
  final Color? otherMonthColor;
  final Color? selectedMonthColor;
  final Color? otherYearColor;
  final Color? selectedYearColor;
  final TextStyle? labelTextStyle;

  const MonthYearSelectionWidget({
    required this.date,
    this.allowedStartDate,
    this.allowedEndDate,
    required this.onChange,
    required this.onDone,
    required this.onCancel,
    super.key,
    this.cancelColor,
    this.doneColor,
    this.otherMonthColor,
    this.selectedMonthColor,
    this.otherYearColor,
    this.selectedYearColor, this.labelTextStyle,
  });

  @override
  State<StatefulWidget> createState() {
    return MonthYearSelectionState();
  }
}

class MonthYearSelectionState extends State<MonthYearSelectionWidget> {
  int month = 0;
  int year = 0;

  @override
  void initState() {
    month = widget.date.month;
    year = widget.date.year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NumberPicker(
                unselectedColor: widget.otherMonthColor,
                selectedColor: widget.selectedMonthColor,

                value: month,
                minValue: 1,
                maxValue: 12,
                onChanged: (value) => change(month: value),
              ),
              NumberPicker(
                unselectedColor: widget.otherMonthColor,
                selectedColor: widget.selectedMonthColor,
                value: year,
                minValue:
                    widget.allowedStartDate == null
                        ? DateTime.now().year - 100
                        : widget.allowedStartDate!.year,
                maxValue:
                    widget.allowedEndDate == null
                        ? DateTime.now().year + 100
                        : widget.allowedEndDate!.year,
                onChanged: (value) => change(year: value),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: widget.onCancel,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Text(
                  "Cancel",
                  style: widget.labelTextStyle ?.copyWith(color:widget.cancelColor),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.onDone(month, year);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Text("Done", style:widget.labelTextStyle ?.copyWith(color:widget.cancelColor)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void change({int? month, int? year}) {
    setState(() {
      this.month = month ?? this.month;
      this.year = year ?? this.year;
    });
    widget.onChange(this.month, this.year);
  }
}

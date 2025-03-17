import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/helper/utils.dart';

import '../helper/theme_helper.dart';
import 'custom_calendar_widget/chart_date_filter_widget.dart';
DateFormat formatter = DateFormat('yyyy-MM-dd');

class FilterComponent extends StatefulWidget {
  final Function(String, {DateTimeRange? range})? onSelectionChange;

  const FilterComponent({super.key, this.onSelectionChange});

  @override
  State<FilterComponent> createState() => _FilterComponentState();
}

class _FilterComponentState extends State<FilterComponent> {
  final List<Map<String, String>> ranges = [
    {"label": "Custom", "key": "custom"},
    {"label": "Today", "key": "today"},
    {"label": "Yesterday", "key": "yesterday"},
    {"label": "Last 7 Days", "key": "last7"},
    {"label": "Last 30 Days", "key": "last30"},
    {"label": "Last Month", "key": "lastMonth"},
    {"label": "Last 90 Days", "key": "last90"},
    {"label": "Last 365 Days", "key": "last365"},
    {"label": "Last 12 Months", "key": "last12Months"},
    {"label": "Last Year", "key": "lastYear"},
  ];

  String selectedKey = "today";
  DateTimeRange? selectedRange;
  DateTimeRange? selectedCustomRange;


  void handleSelection(String key) {
    if(selectedKey!=key) {
      if (key == "custom") {
        // _selectDateRange();
      } else {
        setState(() {
          selectedCustomRange = null;
          selectedKey = key;
          selectedRange = _getDateRange(key);
        });

        widget.onSelectionChange?.call(key, range: selectedRange);
      }
    }
  }

  Future<void> _selectDateRange() async {
    final ThemeData theme = ThemeHelper.lightTheme(context);

    final picked = await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      // Shows only calendar
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      cancelText: translate(TextHelper.cancel),
      barrierColor: Colors.black54,
      // Dim background
      builder: (context, child) {
        return Dialog(
          // Wrap in Dialog for full styling control
          backgroundColor: AppColors.darkBg2, // Ensures full background color
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            height: Responsive.screenH(context, 70),
            decoration: BoxDecoration(
              color: AppColors.darkBg2, // Full background matches app theme
              borderRadius: BorderRadius.circular(12),
            ),
            child: Theme(
              data: theme.copyWith(
                scaffoldBackgroundColor: AppColors.darkBg2,
                cardColor: AppColors.darkBg2,
                colorScheme: theme.colorScheme.copyWith(
                  primary: AppColors.pink,
                  onSurface: AppColors.white,
                  onInverseSurface: AppColors.white,
                  onPrimary: AppColors.white,
                  onPrimaryContainer: AppColors.white,
                  onSurfaceVariant: AppColors.white,
                ),

                textTheme: TextTheme(
                  bodyMedium: TextStyle(color: Colors.white), // Date text color
                  bodySmall:
                      TextStyle(color: Colors.white), // Labels text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.pink), // Button text color
                ),
                dialogBackgroundColor:
                    AppColors.darkBg2, // Ensures full background matches theme
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: child!,
              ),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedKey = "custom";

        selectedCustomRange =
            DateTimeRange(start: picked.start, end: picked.end);
      });

      widget.onSelectionChange?.call("custom", range: selectedCustomRange);
    }
  }

  DateTimeRange _getDateRange(String key) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (key) {
      case "today":
        return DateTimeRange(start: today, end: today);
      case "yesterday":
        final yesterday = today.subtract(Duration(days: 1));
        return DateTimeRange(start: yesterday, end: yesterday);
      case "last7":
        return DateTimeRange(
            start: today.subtract(Duration(days: 6)), end: today);
      case "last30":
        return DateTimeRange(
            start: today.subtract(Duration(days: 29)), end: today);
      case "last90":
        return DateTimeRange(
            start: today.subtract(Duration(days: 89)), end: today);
      case "last365":
        return DateTimeRange(
            start: today.subtract(Duration(days: 364)), end: today);
      case "lastMonth":
        final firstDayLastMonth = DateTime(now.year, now.month - 1, 1);
        final lastDayLastMonth = DateTime(now.year, now.month, 0);
        return DateTimeRange(start: firstDayLastMonth, end: lastDayLastMonth);
      case "last12Months":
        final firstDay = DateTime(now.year, now.month - 12, 1);
        final lastDay = DateTime(now.year, now.month - 0, 0);
        return DateTimeRange(start: firstDay, end: lastDay);
      case "lastYear":
        final firstDayLastYear = DateTime(now.year - 1, 1, 1);
        final lastDayLastYear = DateTime(now.year - 1, 12, 31);
        return DateTimeRange(start: firstDayLastYear, end: lastDayLastYear);
      default:
        return DateTimeRange(start: today, end: today);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFF0B111A), // Dark background
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ranges.map((item) {
            bool isSelected = selectedKey == item["key"];
            return GestureDetector(
                onTap: () => handleSelection(item["key"]!),
                child: (item["key"] != "custom")
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFFF90182)
                              : Color(0xFF141E2D),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Color(0xFFA3AED0).withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          item["label"]!,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : Color(0xFFA3AED0),
                            fontWeight: FontWeight.w600,
                          ),
                        ))
                    : ChartDateFilterWidget(
                        dateBackgroundColor: AppColors.darkBg,
                        weekRowTextColor: AppColors.white,
                        containerColor: AppColors.darkBg,
                        arrowColor: AppColors.subText,
                        currentMonthDateColor: AppColors.white,
                        otherMonthDateColor:
                            AppColors.subText.withValues(alpha: 0.2),
                        selectedBackgroundColor: AppColors.pink,
                        inBetweenColor: AppColors.grey2,
                        cancelTextColor: AppColors.subText,
                        doneTextColor: AppColors.subText,
                        applyCancelButtonColor: AppColors.pink,
                        otherMonthColor: AppColors.subText,
                        selectedMonthColor: AppColors.white,
                        selectedDateColor: AppColors.white,
                        monthYearColor: AppColors.subText,
                        otherYearColor: AppColors.white,
                        dividerColor: AppColors.subText,
                        selectedYearColor: AppColors.subText,
                        buttonTextStyle: getTextTheme().bodyMedium,
                        labelTextStyle: getTextTheme().bodyMedium,
                        onChange: (DateFilterModal date) {
                          // Handle selected date change
                          setState(() {
                            selectedKey = "custom";
                            selectedCustomRange = DateTimeRange(
                                start: DateTime.parse(date.startDate ?? ""),
                                end: DateTime.parse(date.endDate ?? ""));
                          });

                          widget.onSelectionChange
                              ?.call("custom", range: selectedCustomRange);

                          debugPrint(
                              "Selected Date Range: ${date.startDate} to ${date.endDate}");
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0xFFF90182)
                                  : Color(0xFF141E2D),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color:
                                      Color(0xFFA3AED0).withValues(alpha: 0.4)),
                            ),
                            child: selectedCustomRange != null
                                ? Text(
                                    "${formatter.format(selectedCustomRange!.start)} to ${formatter.format(selectedCustomRange!.end)}",
                            style: getTextTheme().bodyMedium?.copyWith(color: AppColors.white),
                            )
                                : Icon(
                                    Icons.calendar_today_sharp,
                                    color: AppColors.subText,
                                  )),
                      ));
          }).toList(),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/cubit/dashboard/dashboard_state.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/utils.dart';

import 'custom_calendar_widget/chart_date_filter_widget.dart';

DateFormat formatter = DateFormat('yyyy-MM-dd');

class FilterComponent extends StatefulWidget {
  final Function(String, {DateTimeRange? range})? onSelectionChange;
  final bool? isDisabled;

  const FilterComponent(
      {super.key, this.onSelectionChange, this.isDisabled = false});

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

  void handleSelection(String key, DashboardState state) {
    if (state.selectedKey != key) {
      if (key == "custom") {
        // _selectDateRange();
      } else {
        // setState(() {
          state.selectedCustomRange = null;
        //   state.selectedKey = key;
        //   state.selectedRange = _getDateRange(key);
        // });
        context
            .read<DashBoardCubit>()
            .updateFilterData(key, _getDateRange(key), null);

        widget.onSelectionChange?.call(key, range: _getDateRange(key));
      }
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
            start: today.subtract(Duration(days: 30)), end: today);
      case "last90":
        return DateTimeRange(
            start: today.subtract(Duration(days: 90)), end: today);
      case "last365":
        return DateTimeRange(
            start: today.subtract(Duration(days: 365)), end: today);
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
    return BlocBuilder<DashBoardCubit, DashboardState>(
      builder: (context, state) {
        print(state.selectedCustomRange);
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: Color(0xFF0B111A), // Dark background
            // borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ranges.map((item) {
                bool isSelected = state.selectedKey == item["key"];
                return GestureDetector(
                    onTap: () {
                      if (widget.isDisabled == true) {
                        CustomToast.show(
                          context: context,
                          message: "Hold on a moment, it's still loading.",
                          status: ToastStatus.warning,
                        );
                      } else {
                        handleSelection(item["key"]!, state);
                      }
                    },

                    child: (item["key"] != "custom")
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: Responsive.screenW(context, 1)),
                            padding: EdgeInsets.symmetric(
                                vertical: Responsive.screenH(context, 1),
                                horizontal: Responsive.screenW(context, 3)),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0xFFF90182)
                                  : Color(0xFF141E2D),
                              borderRadius: BorderRadius.circular(
                                  Responsive.screenW(context, 6)),
                              border: Border.all(
                                  color:
                                      Color(0xFFA3AED0).withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              item["label"]!,
                              style: getTextTheme().bodyMedium?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : Color(0xFFA3AED0),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ))
                        : ChartDateFilterWidget(
                            isDisabled: widget.isDisabled,
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
                              // setState(() {
                              state.selectedKey = "custom";
                              var range = DateTimeRange(
                                  start: DateTime.parse(date.startDate ?? ""),
                                  end: DateTime.parse(date.endDate ?? ""));
                              // });

                              context
                                  .read<DashBoardCubit>()
                                  .updateFilterData("custom", null, range);

                              widget.onSelectionChange?.call("custom",
                                  range: range);

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
                                      color: Color(0xFFA3AED0)
                                          .withValues(alpha: 0.4)),
                                ),
                                child: state.selectedCustomRange != null
                                    ? Text(
                                        "${formatter.format(state.selectedCustomRange!.start)} to ${formatter.format(state.selectedCustomRange!.end)}",
                                        style: getTextTheme()
                                            .bodyMedium
                                            ?.copyWith(color: AppColors.white),
                                      )
                                    : Padding(
                                        padding: DeviceType.isMobile(context)
                                            ? EdgeInsets.zero
                                            : EdgeInsets.symmetric(
                                                vertical: Responsive.screenW(
                                                    context, 1),
                                                horizontal: Responsive.screenW(
                                                    context, 2)),
                                        child: Icon(
                                          Icons.calendar_today_sharp,
                                          color: AppColors.subText,
                                        ),
                                      )),
                          ));
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

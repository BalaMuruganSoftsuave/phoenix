import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar_dates_widget.dart';
import 'calender_widget_modal.dart';
import 'month_year_selection_widget.dart';
import 'week_row_widget.dart';

enum CalenderHeight { h400, h360, h260, h260WithoutScroll }

class CalenderWidget extends StatefulWidget {
  final SelectionChange onChange;
  final DateTime? allowedStartDate;
  final DateTime? allowedEndDate;
  final Selection? settings;
  final CalenderHeight calenderHeight;
  final Color? dateBackgroundColor;
  final Color? weekRowTextColor;
  final Color? arrowColor;
  final Color? currentMonthDateColor;
  final Color? otherMonthDateColor;
  final Color? startEndColor;
  final Color? inBetweenColor;
  final Color? cancelColor;
  final Color? doneColor;
  final Color? otherMonthColor;
  final Color? selectedMonthColor;
  final Color? selectedDateColor;
  final Color? monthAndYearColor;
  final Color? otherYearColor;
  final Color? selectedYearColor;
  final Color? dividerColor;
  final TextStyle? labelTextStyle;

  final bool readonly;

  const CalenderWidget({
    this.allowedStartDate,
    this.allowedEndDate,
    this.settings,
    required this.onChange,
    this.calenderHeight = CalenderHeight.h360,
    this.readonly = false,
    super.key,
    this.dateBackgroundColor,
    this.weekRowTextColor,
    this.arrowColor,
    this.currentMonthDateColor,
    this.otherMonthDateColor,
    this.startEndColor,
    this.inBetweenColor,
    this.cancelColor,
    this.doneColor,
    this.otherMonthColor,
    this.selectedMonthColor,
    this.selectedDateColor,
    this.monthAndYearColor,
    this.otherYearColor,
    this.selectedYearColor,
    this.labelTextStyle,
    this.dividerColor,
  });

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  final select = ValueNotifier(Selection());
  final ValueNotifier<bool> monthSelection = ValueNotifier(false);
  final datesScrollController = ScrollController(keepScrollOffset: true);
  Selection? previousSelection;

  @override
  void initState() {
    if (widget.settings != null) {
      select.value = widget.settings!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isHeight400 = widget.calenderHeight == CalenderHeight.h400;
    final isHeight360 = widget.calenderHeight == CalenderHeight.h360;
    final isHeight260 = widget.calenderHeight == CalenderHeight.h260;

    final isHeight260WithoutScroll =
        widget.calenderHeight == CalenderHeight.h260WithoutScroll;
    return SizedBox(
      height: isHeight400
          ? 400
          : isHeight360
              ? 360
              : isHeight260
                  ? 260
                  : isHeight260WithoutScroll
                      ? 298
                      : 360,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LayoutBuilder(builder: (context, boxConstraints) {
          final widthGreaterThan200 = boxConstraints.maxWidth > 200;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widthGreaterThan200 ? 12 : 0,
                    vertical: isHeight260 || isHeight260WithoutScroll ? 4 : 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: monthSelection,
                      builder: (context, isMonthSelection, __) =>
                          isMonthSelection
                              ? const SizedBox()
                              : InkWell(
                                  onTap: widget.readonly ? null : previous,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.arrow_back_ios,
                                        size: 16, color: widget.arrowColor),
                                  ),
                                ),
                    ),
                    ValueListenableBuilder<Selection>(
                        valueListenable: select,
                        builder: (context, selection, __) {
                          return InkWell(
                            onTap: widget.readonly
                                ? null
                                : () {
                                    monthSelection.value =
                                        !monthSelection.value;
                                    if (monthSelection.value) {
                                      previousSelection = selection;
                                    }
                                  },
                            child: Text(
                                DateFormat(widthGreaterThan200
                                        ? "MMMM yyyy"
                                        : "MMM yyyy")
                                    .format(selection.currentMonth),
                                style: widget.labelTextStyle?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: widget.monthAndYearColor)),
                          );
                        }),
                    ValueListenableBuilder<bool>(
                      valueListenable: monthSelection,
                      builder: (context, isMonthSelection, __) =>
                          isMonthSelection
                              ? const SizedBox()
                              : InkWell(
                                  onTap: widget.readonly ? null : next,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.arrow_forward_ios,
                                        size: 16, color: widget.arrowColor),
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: widget.dateBackgroundColor,
                    margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: ValueListenableBuilder<bool>(
                        valueListenable: monthSelection,
                        builder: (context, isMonthSelection, __) {
                          return isMonthSelection
                              ? MonthYearSelectionWidget(
                                  // user can view any month and year
                                  // allowedStartDate: widget.allowedStartDate,
                                  // allowedEndDate: widget.allowedEndDate,
                                  cancelColor: widget.cancelColor,
                                  doneColor: widget.doneColor,
                                  otherMonthColor: widget.otherMonthColor,
                                  selectedMonthColor: widget.selectedMonthColor,
                                  otherYearColor: widget.otherYearColor,
                                  selectedYearColor: widget.selectedYearColor,
                                  labelTextStyle: widget.labelTextStyle,
                                  date: select.value.start ?? DateTime.now(),
                                  onChange: (month, year) {
                                    select.value = select.value.changeMonth(
                                        DateTime(
                                            year,
                                            month,
                                            select.value.currentMonth.day,
                                            select.value.currentMonth.hour));
                                  },
                                  onDone: (month, year) {
                                    monthSelection.value = false;
                                    previousSelection = null;
                                    select.value = select.value.changeMonth(
                                        DateTime(
                                            year,
                                            month,
                                            select.value.currentMonth.day,
                                            select.value.currentMonth.hour));
                                  },
                                  onCancel: () {
                                    if (previousSelection != null) {
                                      select.value = previousSelection!;
                                    }
                                    monthSelection.value = false;
                                  },
                                )
                              : Column(
                                  children: [
                                    const SizedBox(height: 4),
                                    WeekRowWidget(
                                      widthGreaterThan200,
                                      weekRowTextColor: widget.weekRowTextColor,
                                    ),
                                    const SizedBox(height: 4),
                                    Expanded(
                                        child: CalendarDatesWidget(
                                      select: select,
                                      datesScrollController:
                                          datesScrollController,
                                      isHeight400: isHeight400,
                                      isHeight260: isHeight260,
                                      isHeight260WithoutScroll:
                                          isHeight260WithoutScroll,
                                      readonly: widget.readonly,
                                      allowedStartDate: widget.allowedStartDate,
                                      allowedEndDate: widget.allowedEndDate,
                                      onChange: widget.onChange,
                                      widthGreaterThan200: widthGreaterThan200,
                                      currentMonthDateColor:
                                          widget.currentMonthDateColor,
                                      otherMonthDateColor:
                                          widget.otherMonthDateColor,
                                      startEndColor: widget.startEndColor,
                                      inBetweenColor: widget.inBetweenColor,
                                      selectedDateColor:
                                          widget.selectedDateColor,
                                      labelTextStyle: widget.labelTextStyle,
                                    ))
                                  ],
                                );
                        }),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void previous() {
    var cMonth = select.value.currentMonth.month;
    var year = select.value.currentMonth.year;
    if (cMonth == 1) {
      cMonth = 12;
      year = year - 1;
    } else {
      cMonth = cMonth - 1;
    }
    select.value = select.value.changeMonth(DateTime(year, cMonth,
        select.value.currentMonth.day, select.value.currentMonth.hour));
  }

  void next() {
    var cMonth = select.value.currentMonth.month;
    var year = select.value.currentMonth.year;
    if (cMonth == 12) {
      cMonth = 1;
      year = year + 1;
    } else {
      cMonth = cMonth + 1;
    }
    select.value = select.value.changeMonth(DateTime(year, cMonth,
        select.value.currentMonth.day, select.value.currentMonth.hour));
  }
}

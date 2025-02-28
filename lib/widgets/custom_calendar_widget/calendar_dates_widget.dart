import 'package:flutter/material.dart';

import 'calender_widget_modal.dart';
import 'single_day_widget.dart';

class CalendarDatesWidget extends StatelessWidget {
  const CalendarDatesWidget({
    super.key,
    required this.select,
    required this.datesScrollController,
    required this.isHeight400,
    required this.isHeight260,
    required this.isHeight260WithoutScroll,
    required this.onChange,
    required this.allowedStartDate,
    required this.allowedEndDate,
    required this.readonly,
    required this.widthGreaterThan200, this.currentMonthDateColor, this.otherMonthDateColor, this.startEndColor, this.inBetweenColor, this.selectedDateColor, this.labelTextStyle,
  });

  final ValueNotifier<Selection> select;
  final ScrollController datesScrollController;
  final bool isHeight400;
  final bool isHeight260;
  final bool isHeight260WithoutScroll;
  final SelectionChange onChange;
  final DateTime? allowedStartDate;
  final DateTime? allowedEndDate;
  final bool readonly;
  final bool widthGreaterThan200;
  final Color? currentMonthDateColor;
  final Color? otherMonthDateColor;
  final Color? startEndColor;
  final Color? inBetweenColor;
final Color? selectedDateColor;
final TextStyle? labelTextStyle;

  List<List<Date>> getDates() {
    List<Date> dates = [];
    var day = DateTime.fromMillisecondsSinceEpoch(
        select.value.currentMonth.millisecondsSinceEpoch);
    day = day.subtract(Duration(days: (select.value.currentMonth.day - 1)));
    day = day.subtract(Duration(days: day.weekday));
    while (dates.length < 42) {
      bool selected = false;
      if (select.value.isMultiple &&
          select.value.start != null &&
          select.value.end != null) {
        selected = day.between(select.value.start!, select.value.end!);
      } else if (select.value.start != null) {
        selected = day.isSameDay(select.value.start!);
      }
      dates.add(Date(day,
          isCurrentMonth: day.month == select.value.currentMonth.month,
          isSelected: selected));
      day = day.add(const Duration(days: 1));
    }
    final filteredNewDates = List<List<Date>>.generate(
            6, (index) => dates.sublist(index * 7, (index * 7) + 7))
        .where((week) => week.first.isCurrentMonth || week.last.isCurrentMonth)
        .toList();

    return filteredNewDates;
  }

  bool isDayEnabled(
      DateTime? allowedStartDate, DateTime? allowedEndDate, DateTime date) {
    final isGreaterThanMin = allowedStartDate == null ||
        date.isAfter(allowedStartDate) ||
        date.isAtSameMomentAs(allowedStartDate);
    final isLessThanMax = allowedEndDate == null ||
        date.isBefore(allowedEndDate) ||
        date.isAtSameMomentAs(allowedEndDate);

    return isGreaterThanMin && isLessThanMax;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: select,
        builder: (context, selection, __) {
          var dates = getDates();
          return SizedBox(
            child: Scrollbar(
              controller: datesScrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: datesScrollController,
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final week = dates[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: SizedBox(
                      height: isHeight400
                          ? 44
                          : isHeight260 || isHeight260WithoutScroll
                              ? 30
                              : 38,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: week
                            .map((e) => Flexible(
                                child: SingleDayWidget(
                                    isReadonly: readonly,
                                    isEnabled: isDayEnabled(allowedStartDate,
                                        allowedEndDate, e.day),
                                    select: select,
                                    date: e,
                                    fontSize: widthGreaterThan200 ? 14 : 12,
                                    onChange: onChange,
                                  currentMonthDateColor: currentMonthDateColor,
                                  otherMonthDateColor: otherMonthDateColor,
                                  startEndColor: startEndColor,
                                  inBetweenColor: inBetweenColor,
                                  selectedDateColor: selectedDateColor,
                                  labelTextStyle: labelTextStyle,
                                )))
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}

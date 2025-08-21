import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';

import 'calendar_widget.dart';
import 'calender_widget_modal.dart';

class DateFilterModal {
  String? dateFilterType;
  String? startDate;
  String? endDate;

  DateFilterModal({this.dateFilterType, this.startDate, this.endDate});

  DateFilterModal.fromJson(Map<String, dynamic> json) {
    dateFilterType = json['dateFilterType'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['dateFilterType'] = dateFilterType;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}

class ChartDateFilterWidget extends StatefulWidget {
  final void Function(DateFilterModal date) onChange;
  final Color? dateBackgroundColor;
  final Color? weekRowTextColor;
  final Color? containerColor;
  final Color? arrowColor;
  final Color? currentMonthDateColor;
  final Color? otherMonthDateColor;
  final Color? selectedBackgroundColor;
  final Color? inBetweenColor;
  final Color? cancelTextColor;
  final Color? doneTextColor;
  final Color? otherMonthColor;
  final Color? selectedMonthColor;
  final Color? selectedDateColor;
  final Color? monthYearColor;
  final Color? otherYearColor;
  final Color? selectedYearColor;
  final Color? applyCancelButtonColor;
  final Color? dividerColor;
  final Widget? child;
  final TextStyle? buttonTextStyle;
  final TextStyle? labelTextStyle;
  final bool? isDisabled;

  const ChartDateFilterWidget({
    required this.onChange,
    super.key,
    this.dateBackgroundColor,
    this.weekRowTextColor,
    this.containerColor,
    this.arrowColor,
    this.currentMonthDateColor,
    this.otherMonthDateColor,
    this.selectedBackgroundColor,
    this.inBetweenColor,
    this.cancelTextColor,
    this.doneTextColor,
    this.otherMonthColor,
    this.selectedMonthColor,
    this.selectedDateColor,
    this.monthYearColor,
    this.otherYearColor,
    this.selectedYearColor,
    this.child,
    this.buttonTextStyle,
    this.labelTextStyle,
    this.applyCancelButtonColor,
    this.dividerColor, this.isDisabled=false,
  });

  @override
  State<ChartDateFilterWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<ChartDateFilterWidget>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  final LayerLink link = LayerLink();
  final selectedDateRange = DateFilterModal();
  final isMenuOpen = ValueNotifier(false);
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void openMenu(BuildContext context) {
    _animationController.forward();
    _overlayEntry = _overlayEntryBuilderForCustomDatePicker();
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen.value = true;
  }

  void closeMenu() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
    }
    _animationController.reverse();
    isMenuOpen.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: InkWell(
        key: _key,
        onTap:widget.isDisabled==true?null :() {
          if (isMenuOpen.value) {
            closeMenu();
          } else {
            openMenu(context);
          }
        },
        child: widget.child ??
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.containerColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    "Select Custom Date",
                    style: widget.labelTextStyle,
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black54),
                ],
              ),
            ),
      ),
    );
  }
  OverlayEntry _overlayEntryBuilderForCustomDatePicker() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // GestureDetector to detect taps outside the pop-up
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  closeMenu();
                },
                child: Container(), // Empty container to capture taps
              ),
            ),
            Positioned(
              top: 100, // Adjust position as needed
              left: 20,
              right: 20,
              child: Material(
                elevation: 5,
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.text)),
                color: widget.containerColor, // Background container color
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CalenderWidget(
                        dateBackgroundColor: widget.dateBackgroundColor,
                        weekRowTextColor: widget.weekRowTextColor,
                        currentMonthDateColor: widget.currentMonthDateColor,
                        otherMonthDateColor: widget.otherMonthDateColor,
                        startEndColor: widget.selectedBackgroundColor,
                        inBetweenColor: widget.inBetweenColor,
                        arrowColor: widget.arrowColor,
                        cancelColor: widget.cancelTextColor,
                        doneColor: widget.doneTextColor,
                        otherMonthColor: widget.otherMonthColor,
                        selectedMonthColor: widget.selectedMonthColor,
                        selectedDateColor: widget.selectedDateColor,
                        monthAndYearColor: widget.monthYearColor,
                        otherYearColor: widget.otherYearColor,
                        selectedYearColor: widget.selectedYearColor,
                        labelTextStyle: widget.labelTextStyle,
                        dividerColor: widget.dividerColor,
                        settings: Selection(isMultiple: true),
                        allowedEndDate: DateTime.now(),
                        onChange: (range) {
                          if (range.start != null) {
                            selectedDateRange.startDate =
                                range.start.toString();
                          }
                          if (range.end != null) {
                            selectedDateRange.endDate =
                                range.end.toString();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Divider(height: 1, color: widget.dividerColor),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  closeMenu();
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(0, 50),
                                  side: BorderSide(color: AppColors.subText),
                                  foregroundColor: Colors.white,
                                  textStyle: widget.buttonTextStyle ??
                                      const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: widget.buttonTextStyle?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  if(selectedDateRange.endDate!=null &&selectedDateRange.startDate!=null ) {
                                    widget.onChange(selectedDateRange);
                                    closeMenu();
                                  }else{
                                    CustomToast.show(context: context, message: "Please Select the date range", status: ToastStatus.warning);
                                  }

                                },
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(0, 50),
                                  backgroundColor:
                                  widget.applyCancelButtonColor ??
                                      Colors.green,
                                  foregroundColor: Colors.white,
                                  textStyle: widget.buttonTextStyle ??
                                      const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Apply",
                                  style: widget.buttonTextStyle?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}

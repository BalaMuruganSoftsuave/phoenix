import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/utils.dart';

class NumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int value;
  final ValueChanged<int> onChanged;

  const NumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
  });

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(
      initialItem: widget.value - widget.minValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.borderColor, width: 2),
                  bottom: BorderSide(color: AppColors.borderColor, width: 2),
                ),
              )),
      SizedBox(
        height: 150, // Adjusted height
        child: ListWheelScrollView.useDelegate(
          controller: _scrollController,
          physics: const FixedExtentScrollPhysics(),
          itemExtent: 50,
          onSelectedItemChanged: (index) {
            int newValue = widget.minValue + index;
            widget.onChanged(newValue);
            HapticFeedback.selectionClick();
          },
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              final value = widget.minValue + index;
              final isSelected = value == widget.value;
              return Container(
                alignment: Alignment.center,
                height: 50,
                decoration: null,
                child: Text(
                  "$value:00",
                  style: getTextTheme().bodyMedium?.copyWith(
                        fontSize: 20,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.white : AppColors.subText,
                      ),
                ),
              );
            },
            childCount: widget.maxValue - widget.minValue + 1,
          ),
        ),
      ),

    ]);
  }
}

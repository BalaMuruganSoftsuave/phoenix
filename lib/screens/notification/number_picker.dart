import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoenix/helper/color_helper.dart';

typedef TextMapper = String Function(String numberText);

class NumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int value;
  final Axis axis;
  final int step;
  final bool haptics;
  final double itemHeight;
  final double itemWidth;
  final int itemCount;
  final Decoration? decoration;
  final bool zeroPad;
  final TextMapper? textMapper;
  final ValueChanged<int> onChanged;

  const NumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
    this.axis = Axis.vertical,
    this.step = 1,
    this.haptics = false,
    this.itemHeight = 40,
    this.itemWidth = 60,
    this.itemCount = 3,
    this.decoration,
    this.zeroPad = false,
    this.textMapper,
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
      initialItem: (widget.value - widget.minValue) ~/ widget.step,
    );
  }

  bool get isVertical => widget.axis == Axis.vertical;
  double get itemExtent => isVertical ? widget.itemHeight : widget.itemWidth;
  int get itemCount => ((widget.maxValue - widget.minValue) ~/ widget.step) + 1;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: isVertical ? 0 : 1,
      child: SizedBox(
        height: isVertical ? widget.itemHeight * widget.itemCount : widget.itemWidth * 3,
        width: isVertical ? widget.itemWidth * 3 : widget.itemHeight * widget.itemCount,
        child: ListWheelScrollView.useDelegate(
          controller: _scrollController,
          physics: FixedExtentScrollPhysics(),
          itemExtent: itemExtent,
          onSelectedItemChanged: (index) {
            int newValue = widget.minValue + (index * widget.step);
            widget.onChanged(newValue);
            if (widget.haptics) {
              HapticFeedback.selectionClick();
            }
          },
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              final value = widget.minValue + (index * widget.step);
              final isSelected = value == widget.value;
              final textStyle = TextStyle(
                fontSize: isSelected ? 22 : 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.white : AppColors.subText,
              );
              return RotatedBox(
                quarterTurns: isVertical ? 0 : -1,
                child: Center(
                  child: Text(
                    widget.textMapper?.call(value.toString()) ?? "$value : 00",
                    style: textStyle,
                  ),
                ),
              );
            },
            childCount: itemCount,
          ),
        ),
      ),
    );
  }
}

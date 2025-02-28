import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef TextMapper = String Function(String numberText);

class NumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int value;
  final ValueChanged<int> onChanged;
  final int itemCount;
  final int step;
  final double itemHeight;
  final double itemWidth;
  final Axis axis;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final bool haptics;
  final TextMapper? textMapper;
  final bool zeroPad;
  final Decoration? decoration;
  final Color? unselectedColor;
  final Color? selectedColor;
  final TextStyle? labelTextStyle;


  const NumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
    this.itemCount = 3,
    this.step = 1,
    this.itemHeight = 50,
    this.itemWidth = 100,
    this.axis = Axis.vertical,
    this.textStyle,
    this.selectedTextStyle,
    this.haptics = false,
    this.decoration,
    this.zeroPad = false,
    this.textMapper,
    this.unselectedColor,
    this.selectedColor, this.labelTextStyle,
  })  : assert(minValue <= value),
        assert(value <= maxValue);

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final initialOffset =
        (widget.value - widget.minValue) ~/ widget.step * itemExtent;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    var indexOfMiddleElement = (_scrollController.offset / itemExtent).round();
    indexOfMiddleElement = indexOfMiddleElement.clamp(0, itemCount - 1);
    final intValueInTheMiddle =
    _intValueFromIndex(indexOfMiddleElement + additionalItemsOnEachSide);

    if (widget.value != intValueInTheMiddle) {
      widget.onChanged(intValueInTheMiddle);
      if (widget.haptics) {
        HapticFeedback.selectionClick();
      }
    }
    Future.delayed(
      const Duration(milliseconds: 100),
      _maybeCenterValue,
    );
  }

  @override
  void didUpdateWidget(NumberPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _maybeCenterValue();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  bool get isScrolling => _scrollController.position.isScrollingNotifier.value;
  bool get isVertical => widget.axis == Axis.vertical;
  double get itemExtent => isVertical ? widget.itemHeight : widget.itemWidth;
  int get itemCount => (widget.maxValue - widget.minValue) ~/ widget.step + 1;
  int get listItemsCount => itemCount + 2 * additionalItemsOnEachSide;
  int get additionalItemsOnEachSide => (widget.itemCount - 1) ~/ 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
      isVertical ? widget.itemWidth : widget.itemCount * widget.itemWidth,
      height:
      isVertical ? widget.itemCount * widget.itemHeight : widget.itemHeight,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (not) {
          if (not.dragDetails?.primaryVelocity == 0) {
            Future.microtask(_maybeCenterValue);
          }
          return true;
        },
        child: Stack(
          children: [
            ListView.builder(
              itemCount: listItemsCount,
              scrollDirection: widget.axis,
              controller: _scrollController,
              itemExtent: itemExtent,
              itemBuilder: _itemBuilder,
              padding: EdgeInsets.zero,
            ),
            _NumberPickerSelectedItemDecoration(
              axis: widget.axis,
              itemExtent: itemExtent,
              decoration: widget.decoration,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final value = _intValueFromIndex(index % itemCount);
    final isSelected = value == widget.value;

    final defaultStyle = widget.labelTextStyle ?? TextStyle(
      color: widget.unselectedColor ?? Colors.grey,
      fontSize: 16,
    );

    final selectedStyle = widget.labelTextStyle ?? TextStyle(
      fontWeight: FontWeight.w600,
      color: widget.selectedColor ?? Colors.white,
      fontSize: 18,
    );

    final isExtra = (index < additionalItemsOnEachSide ||
        index >= listItemsCount - additionalItemsOnEachSide);
    final itemStyle = isSelected ? selectedStyle : defaultStyle;

    final child = isExtra
        ? const SizedBox.shrink()
        : Text(
      _getDisplayedValue(value),
      style: itemStyle,
    );

    return Container(
      width: widget.itemWidth,
      height: widget.itemHeight,
      alignment: Alignment.center,
      child: child,
    );
  }

  String _getDisplayedValue(int value) {
    final text = widget.zeroPad
        ? value.toString().padLeft(widget.maxValue.toString().length, '0')
        : value.toString();
    return widget.textMapper?.call(text) ?? text;
  }

  int _intValueFromIndex(int index) {
    index -= additionalItemsOnEachSide;
    index %= itemCount;
    return widget.minValue + index * widget.step;
  }

  void _maybeCenterValue() {
    if (_scrollController.hasClients && !isScrolling) {
      int diff = widget.value - widget.minValue;
      int index = diff ~/ widget.step;
      _scrollController.animateTo(
        index * itemExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }
}

class _NumberPickerSelectedItemDecoration extends StatelessWidget {
  final Axis axis;
  final double itemExtent;
  final Decoration? decoration;

  const _NumberPickerSelectedItemDecoration({
    required this.axis,
    required this.itemExtent,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final isVertical = axis == Axis.vertical;
    return Center(
      child: IgnorePointer(
        child: Container(
          width: isVertical ? double.infinity : itemExtent,
          height: isVertical ? itemExtent : double.infinity,
          decoration: decoration,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/screens/notification/number_picker.dart';


class TimePickerWidget extends StatefulWidget {
  final TimeOfDay selectedTime;
  final Function(TimeOfDay) onTimeSelected;

  const TimePickerWidget({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.lines),
                  bottom: BorderSide(color: AppColors.lines),
                ),
              ),
            ),
            Expanded(
              child: NumberPicker(
                value: _selectedTime.hour == 0 ? 24 : _selectedTime.hour,
                minValue: 1,
                maxValue: 24,
                onChanged: (value) {
                  debugPrint("Selected Hour: $value");
                  setState(() {
                    _selectedTime = TimeOfDay(hour: value, minute: _selectedTime.minute);
                  });
                  widget.onTimeSelected(_selectedTime);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

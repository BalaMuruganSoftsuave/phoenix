import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/helper/utils.dart';

class CustomTimePicker extends StatefulWidget {
  final Function(String) onTimeChanged;
  final String initialTime; // Expected format: "hh:mm"

  const CustomTimePicker({
    super.key,
    required this.onTimeChanged,
    this.initialTime = "01:00",
  });

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  int selectedHour = 1;
  bool isAm = true;
  @override
  void initState() {
    super.initState();
    _initializeTime(widget.initialTime);
  }

  void _initializeTime(String time) {
    try {
      List<String> parts = time.split(':');
      int hour = int.parse(parts[0]);

      setState(() {
        selectedHour = (hour == 0 || hour == 12) ? 12 : hour % 12;
        isAm = hour < 12;
      });
    } catch (e) {
      // Fallback to default time if parsing fails
      selectedHour = 1;
      isAm = true;
    }
  }
  String getFormattedTime() {
    int hour24;

    if (isAm && selectedHour == 12) {
      hour24 = 0; // 12 AM should be 00:00
    }  else {
      hour24 = isAm ? selectedHour : selectedHour + 12;
    }

    return '${hour24.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hour Picker
        SizedBox(
          width: 100,
          height: 100,
          child: CupertinoPicker(
            useMagnifier: true,
            scrollController:
                FixedExtentScrollController(initialItem: selectedHour - 1),
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedHour = index + 1;
              });
              widget.onTimeChanged(getFormattedTime());
            },
            children: List.generate(12, (index) {
              return Center(
                  child: Text('${index + 1}:00',
                      style: getTextTheme().bodyMedium?.copyWith(fontSize: 20, color: Colors.white)));
            }),
          ),
        ),
        SizedBox(width: 10),
        // AM/PM Picker
        SizedBox(
          width: 80,
          height: 100,
          child: CupertinoPicker(
            scrollController:
                FixedExtentScrollController(initialItem: isAm ? 0 : 1),
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              setState(() {
                isAm = index == 0;
              });
              widget.onTimeChanged(getFormattedTime());
            },
            children:  [
              Center(
                  child: Text('AM',
                      style: getTextTheme().bodyMedium?.copyWith(fontSize: 20, color: Colors.white))),
              Center(
                  child: Text('PM',
                      style: getTextTheme().bodyMedium?.copyWith(fontSize: 20, color: Colors.white))),
            ],
          ),
        ),
      ],
    );
  }
}

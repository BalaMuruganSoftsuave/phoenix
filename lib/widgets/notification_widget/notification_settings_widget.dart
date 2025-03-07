import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/widgets/notification_widget/day_picker_widget.dart';
import 'package:phoenix/widgets/notification_widget/radio_button_widget.dart';
import 'package:phoenix/widgets/notification_widget/time_picker_widget.dart';

class NotificationSettingsWidget extends StatefulWidget {
  final int selectedOption;
  final TimeOfDay selectedTime;
  final String selectedDay;
  final Function(int) onOptionChanged;
  final Function(TimeOfDay) onTimeChanged;
  final Function(String) onDayChanged;
  final Function(Map<String, dynamic>) onSaveSettings;

  const NotificationSettingsWidget({
    super.key,
    required this.selectedOption,
    required this.selectedTime,
    required this.selectedDay,
    required this.onOptionChanged,
    required this.onTimeChanged,
    required this.onDayChanged,
    required this.onSaveSettings,
  });

  @override
  _NotificationSettingsWidgetState createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  late int _selectedOption;
  late TimeOfDay _selectedTime;
  late String _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
    _selectedTime = widget.selectedTime;
    _selectedDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 55.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 12.0,right: 24.0,bottom: 12.0,left: 24.0),
            decoration: BoxDecoration(
                color: AppColors.notificationCardBackground,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TextHelper.notificationSchedule,
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white),
                ),

                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(border: Border.all(color: AppColors.white,width: 1),
                  borderRadius: BorderRadius.circular(5)),
                child:IconButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_sharp, color: AppColors.white),
                ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ListView.builder(
              itemCount: notificationConfigurationItem.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return  RadioButtonWidget(
                  value: int.parse(notificationConfigurationItem[index].id??"-1"),
                  text: notificationConfigurationItem[index].name??"",
                  selectedValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value!;
                      widget.onOptionChanged(value);
                    });
                  },
                );
              }),
          if (_selectedOption == 1) ...[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 40,),
                Expanded(
                  child: Text(TextHelper.selectTheTime,
                      style: TextStyle(color: AppColors.seaBlue, fontSize: 16)),
                ),
                Expanded(
                  child: TimePickerWidget(
                    selectedTime: _selectedTime,
                    onTimeSelected: (newTime) {
                      setState(() {
                        _selectedTime = newTime;
                        widget.onTimeChanged(newTime);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
          if (_selectedOption == 2) ...[
            SizedBox(height: 20),
            Row(

              children: [
                SizedBox(width: 35,),
                Text(TextHelper.selectTheDay,
                    style: TextStyle(color: AppColors.seaBlue, fontSize: 16)),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: DayPickerWidget(
                onDaySelected: (newDay) {
                  setState(() {
                    _selectedDay = newDay;
                    widget.onDayChanged(newDay);
                    debugPrint("Selected Day: $_selectedDay");
                  });
                },
                selectedDay: _selectedDay,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 35,),
                Expanded(
                  child: Text(TextHelper.selectTheTime,
                      style: TextStyle(color: AppColors.seaBlue, fontSize: 16)),
                ),
                Expanded(
                  child: TimePickerWidget(
                    selectedTime: _selectedTime,
                    onTimeSelected: (newTime) {
                      setState(() {
                        _selectedTime = newTime;
                        widget.onTimeChanged(newTime);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 20),
          Center(
            child:SizedBox(
              width:150,
            height: 40,
            child: ElevatedButton(
              onPressed: ()    {  Map<String, dynamic> notificationSettings = {
    'selectedOption': _selectedOption,
    'selectedTime': _selectedOption == 1 || _selectedOption == 2 ? _selectedTime : null,
    'selectedDay': _selectedOption == 2 ? _selectedDay : null,
    };

    widget.onSaveSettings(notificationSettings);
    Navigator.pop(context);
  },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(TextHelper.save, style: TextStyle(color: AppColors.white,fontSize: 16)),
            ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:phoenix/cubit/notification/notification_cubit.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/widgets/notification_widget/day_picker_widget.dart';
import 'package:phoenix/widgets/notification_widget/radio_button_widget.dart';

import 'time_picker.dart';

class NotificationSettingsWidget extends StatefulWidget {
  final int selectedOption;
  final String selectedTime;
  final String selectedDay;
  final Function(int) onOptionChanged;
  final Function(String) onTimeChanged;
  final Function(String) onDayChanged;
  final Function(Map<String, dynamic>) onSaveSettings;
  final bool? isLoading;
  final bool? isLoadingSaving;

  const NotificationSettingsWidget({
    Key? key,
    required this.selectedOption,
    required this.selectedTime,
    required this.selectedDay,
    required this.onOptionChanged,
    required this.onTimeChanged,
    required this.onDayChanged,
    required this.onSaveSettings,
    this.isLoading = false,
    this.isLoadingSaving = false,
  }) : super(key: key);

  @override
  _NotificationSettingsWidgetState createState() => _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState extends State<NotificationSettingsWidget> {
  late int _selectedOption;
  late String _selectedTime;
  late String _selectedDay;
  String error = "";

  final FocusNode _optionFocusNode = FocusNode();
  final FocusNode _timeFocusNode = FocusNode();
  final FocusNode _dayFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
    _selectedTime = widget.selectedTime;
    _selectedDay = widget.selectedDay;
  }

  @override
  void dispose() {
    _optionFocusNode.dispose();
    _timeFocusNode.dispose();
    _dayFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: Responsive.screenW(context, 100),
        padding: const EdgeInsets.only(bottom: 55.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 12.0, right: 24.0, bottom: 12.0, left: 24.0),
                decoration: BoxDecoration(
                    color: AppColors.notificationCardBackground,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TextHelper.notificationSchedule,
                      style: getTextTheme().bodyMedium?.copyWith(
                          fontSize: Responsive.fontSize(context, 4),
                          fontWeight: FontWeight.bold,
                          color: AppColors.white),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.white, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: IconButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_sharp, color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (widget.isLoading == true) ...[
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.pink,
                  ),
                )
              ],
              if (widget.isLoading == false) ...[
                ListView.builder(
                    itemCount: notificationConfigurationItem.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Focus(
                        focusNode: _optionFocusNode,
                        child: RadioButtonWidget(
                          value: int.parse(
                              notificationConfigurationItem[index].id ?? "-1"),
                          text: notificationConfigurationItem[index].name ?? "",
                          selectedValue: _selectedOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value!;
                              widget.onOptionChanged(value);
                            });
                          },
                        ),
                      );
                    }),
                if (_selectedOption == 2) ...[
                  Row(
                    children: [
                      SizedBox(
                        width: 35,
                      ),
                      Text(TextHelper.selectTheDay,
                          style:
                          getTextTheme().bodyMedium?.copyWith(color: AppColors.seaBlue, fontSize: Responsive.fontSize(context, 3),)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child:  Focus(
                  focusNode: _dayFocusNode,
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
                  ),
                  SizedBox(height: 15),
                ],
                if (_selectedOption == 1 || _selectedOption == 2) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 35,
                      ),
                      Expanded(
                        child: Text(TextHelper.selectTheTime,
                            style: getTextTheme().bodyMedium?.copyWith(
                                color: AppColors.seaBlue, fontSize: Responsive.fontSize(context, 3),)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Focus(
                          focusNode: _timeFocusNode,
                          child: CustomTimePicker(
                            initialTime: _selectedTime,
                            onTimeChanged: (time) {
                              setState(() {
                                _selectedTime = time;
                                widget.onTimeChanged(time);
                              });
                            },
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    error,
                    style: getTextTheme()
                        .displayLarge
                        ?.copyWith(color: AppColors.red),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          error = "";
                        });
                        if (_selectedOption != -1) {
                          if (_selectedOption == 2 && _selectedDay.isEmpty) {
                            setState(() {
                              error = "Please select any day";
                            });
                          } else {
                            // Map<String, dynamic> notificationSettings = {
                            //   'selectedOption': _selectedOption,
                            //   'selectedTime':
                            //       _selectedOption == 1 || _selectedOption == 2
                            //           ? _selectedTime
                            //           : null,
                            //   'selectedDay':
                            //       _selectedOption == 2 ? _selectedDay : null,
                            // };
                            var timezone =
                                await FlutterTimezone.getLocalTimezone();
                            var body = {
                              "NotificationType":
                                  notificationConfigurationItem[_selectedOption]
                                      .name
                                      ?.toLowerCase(),
                              "AdminTimezone": timezone,
                            };
                            if (_selectedOption == 1 || _selectedOption == 2) {
                              body['TriggerTime'] = _selectedTime;
                            }
                            if (_selectedOption == 2) {
                              body['WeekDay'] = _selectedDay;
                            }
                            try {
                             var res= await getCtx(context)
                                  ?.read<NotificationCubit>()
                                  .setNotificationConfiguration(context, body);
                              back();
                            } catch (e) {
                              setState(() {
                                error = "Failed to Update";
                              });
                            }
                            widget.onSaveSettings({});
                          }
                        } else {
                          setState(() {
                            error = "Please select any option";
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: widget.isLoadingSaving == true
                          ? SizedBox(
                              height: 40,
                              width: 40,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                ),
                              ),
                            )
                          : Text(TextHelper.save,
                              style: getTextTheme().bodyMedium?.copyWith(
                                  color: AppColors.white, fontSize: Responsive.fontSize(context, 4),fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

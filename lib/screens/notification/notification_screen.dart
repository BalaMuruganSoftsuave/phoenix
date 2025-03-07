import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/widgets/notification_widget/notification_list_widget.dart';
import 'package:phoenix/widgets/notification_widget/notification_settings_widget.dart';
import 'package:phoenix/widgets/profile_menu_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int selectedOption = 0;
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedDay = "";
  var hour = 0;
  var minutes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B111A),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: Responsive.boxH(context, 10),
              child: AppBar(
                backgroundColor: AppColors.darkBg,
                centerTitle: true,
                title: SvgPicture.asset(
                  Assets.imagesPhoenixLogo,
                  width: Responsive.boxW(context, 15),
                  height: Responsive.boxH(context, 5),
                ),
                actions: [
                  ProfilePopupMenu(
                    userName: "John Doe",
                    onLogout: () {
                      showLogoutDialog(context, () {});
                      debugPrint("User logged out");
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      TextHelper.notification,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        backgroundColor: AppColors.darkBg2,
                        builder: (context) => NotificationSettingsWidget(
                          selectedOption: selectedOption,
                          selectedTime: selectedTime,
                          selectedDay: selectedDay,
                          onOptionChanged: (value) => setState(() => selectedOption = value),
                          onTimeChanged: (time) => setState(() => selectedTime = time),
                          onDayChanged: (day) => setState(() => selectedDay = day),
                          onSaveSettings: (settings){
                            setState(() {
                              selectedOption=settings['selectedOption'];
                              selectedTime=settings['selectedTime'] ?? selectedTime;
                              selectedDay=settings['selectedDay'] ?? selectedDay;
                            });
                            debugPrint("SelectedOption: $selectedOption");
                            debugPrint("SelectedTime: $selectedTime");
                            debugPrint("SelectedDay: $selectedDay");

                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.settings, color: AppColors.subText),
                  ),
                ],
              ),
            ),
            Expanded(
              child: NotificationListWidget(
                title: "Hourly Summary",
                time: "41 minutes ago",
                description: "Total new subscription count and earnings.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

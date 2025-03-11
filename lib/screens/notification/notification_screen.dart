import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoenix/cubit/notification/notification_cubit.dart';
import 'package:phoenix/cubit/notification/notification_state.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/widgets/loader.dart';
import 'package:phoenix/widgets/notification_widget/notification_list_widget.dart';
import 'package:phoenix/widgets/notification_widget/notification_settings_widget.dart';
import 'package:phoenix/widgets/profile_menu_button.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final ValueNotifier<int> selectedOption = ValueNotifier<int>(-1);
  final ValueNotifier<String> selectedTime = ValueNotifier<String>("1:00");
  final ValueNotifier<String> selectedDay = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 10),
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
                    onPressed: () async {
                      showLoader(context);
                      var res= await context
                          .read<NotificationCubit>()
                          .getNotificationConfiguration(context);
                      hideLoader(context);
                      if(res) {
                        showModalBottomSheet(
                          isDismissible: false,
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          backgroundColor: AppColors.darkBg2,
                          builder: (context) =>
                          const NotificationSettingsModal(),
                        );
                      }
                    },
                    icon: Icon(Icons.settings, color: AppColors.subText),
                  ),
                ],
              ),
            ),
            Expanded(
              child: NotificationListWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSettingsModal extends StatefulWidget {
  const NotificationSettingsModal({super.key});

  @override
  State<NotificationSettingsModal> createState() =>
      _NotificationSettingsModalState();
}

class _NotificationSettingsModalState extends State<NotificationSettingsModal> {
  int selectedOption = -1;
  String selectedTime = "1:00";
  String selectedDay = "";

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    final state = context.read<NotificationCubit>().state;
    final notificationType =
        state.notificationConfiguration?.result?.notificationType ?? "";

    for (var e in notificationConfigurationItem) {
      if ((e.name ?? "").toLowerCase().trim() ==
          notificationType.toLowerCase().trim()) {
        int selectedId = int.tryParse(e.id ?? "-1") ?? -1;

        // Delay state update to avoid build conflicts
        setState(() {
          selectedOption = selectedId;

          if (selectedId == 1) {
            selectedTime =
                state.notificationConfiguration?.result?.triggerTime ?? "";
          } else if (selectedId == 2) {
            selectedDay =
                state.notificationConfiguration?.result?.weekDay ?? "";
            selectedTime =
                state.notificationConfiguration?.result?.triggerTime ?? "";
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return NotificationSettingsWidget(
          isLoading: state.getNotificationReqState == ProcessState.loading,
          isLoadingSaving:
              state.setNotificationReqState == ProcessState.loading,
          selectedOption: selectedOption,
          selectedTime: selectedTime,
          selectedDay: selectedDay,
          onOptionChanged: (value) {
            setState(() {
              selectedOption = value;
            });
          },
          onTimeChanged: (time) {
            setState(() {
              selectedTime = time;
            });
          },
          onDayChanged: (day) {
            setState(() {
              selectedDay = day;
            });
          },
          onSaveSettings: (settings) async {

          },
        );
      },
    );
  }
}

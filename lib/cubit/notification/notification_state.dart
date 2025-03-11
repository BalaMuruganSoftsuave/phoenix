import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/models/notification/notification_configuration_model.dart';

class NotificationState {
  ProcessState? getNotificationReqState;
  ProcessState? setNotificationReqState;
  NotificationConfigurationResponse? notificationConfiguration;

  NotificationState({
    this.getNotificationReqState = ProcessState.none,
    this.setNotificationReqState = ProcessState.none,
    this.notificationConfiguration,
  });

  NotificationState copyWith(
      {ProcessState? getNotificationReqState,
      NotificationConfigurationResponse? notificationConfiguration,
      ProcessState? setNotificationReqState}) {
    return NotificationState(
        getNotificationReqState:
            getNotificationReqState ?? this.getNotificationReqState,
        notificationConfiguration:
            notificationConfiguration ?? this.notificationConfiguration,
        setNotificationReqState:
            setNotificationReqState ?? this.setNotificationReqState);
  }
}

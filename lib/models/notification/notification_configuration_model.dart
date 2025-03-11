class NotificationConfigurationResponse {
  NotificationConfigurationResult? result;

  NotificationConfigurationResponse({this.result});

  NotificationConfigurationResponse.fromJson(Map<String, dynamic> json) {
    result =
    json['Result'] != null ?  NotificationConfigurationResult.fromJson(json['Result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['Result'] = result!.toJson();
    }
    return data;
  }
}

class  NotificationConfigurationResult {
  int? id;
  int? adminId;
  String? notificationType;
  String? adminUserTimezone;
  String? weekDay;
  String? triggerTime;
  String? lastTriggerAt;
  String? createdAt;
  String? updatedAt;

  NotificationConfigurationResult(
      {this.id,
        this.adminId,
        this.notificationType,
        this.adminUserTimezone,
        this.weekDay,
        this.triggerTime,
        this.lastTriggerAt,
        this.createdAt,
        this.updatedAt});

  NotificationConfigurationResult.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    adminId = json['AdminId'];
    notificationType = json['NotificationType'];
    adminUserTimezone = json['AdminUserTimezone'];
    weekDay = json['WeekDay'];
    triggerTime = json['TriggerTime'];
    lastTriggerAt = json['LastTriggerAt'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['AdminId'] = adminId;
    data['NotificationType'] = notificationType;
    data['AdminUserTimezone'] = adminUserTimezone;
    data['WeekDay'] = weekDay;
    data['TriggerTime'] = triggerTime;
    data['LastTriggerAt'] = lastTriggerAt;
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;
    return data;
  }
}

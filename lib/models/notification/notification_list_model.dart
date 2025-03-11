class NotificationListResponse {
  int? totalCount;
  List<NotificationListResult>? result;

  NotificationListResponse({this.totalCount, this.result});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'];
    if (json['Result'] != null) {
      result = <NotificationListResult>[];
      json['Result'].forEach((v) {
        result!.add(NotificationListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCount'] = totalCount;
    if (result != null) {
      data['Result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationListResult {
  int? id;
  int? adminId;
  String? title;
  String? body;
  Metadata? metadata;
  String? createdAt;
  String? updatedAt;

  NotificationListResult(
      {this.id,
      this.adminId,
      this.title,
      this.body,
      this.metadata,
      this.createdAt,
      this.updatedAt});

  NotificationListResult.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    adminId = json['AdminId'];
    title = json['Title'];
    body = json['Body'];
    metadata = json['Metadata'] != null
        ? new Metadata.fromJson(json['Metadata'])
        : null;
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['AdminId'] = adminId;
    data['Title'] = title;
    data['Body'] = body;
    if (metadata != null) {
      data['Metadata'] = metadata!.toJson();
    }
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;
    return data;
  }
}

class Metadata {
  String? count;
  String? amount;

  Metadata({this.count, this.amount});

  Metadata.fromJson(Map<String, dynamic> json) {
    count = '${json['count'] ?? 0}';
    amount = '${json['amount'] ?? 0}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['amount'] = amount;
    return data;
  }
}

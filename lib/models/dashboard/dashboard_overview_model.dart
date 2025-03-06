class DashBoardOverViewResponse {
  List<Result>? result;

  DashBoardOverViewResponse({this.result});

  DashBoardOverViewResponse.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <Result>[];
      json['Result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['Result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? label;
  double? approvedOrders;
  double? averageOrderValue;
  double? approvalPercentage;
  double? abandonCartRatio;

  Result(
      {this.label,
      this.approvedOrders,
      this.averageOrderValue,
      this.approvalPercentage,
      this.abandonCartRatio});

  Result.fromJson(Map<String, dynamic> json) {
    label = json['Label'];
    approvedOrders = double.parse(json['ApprovedOrders'].toString());
    averageOrderValue = double.parse(json['AverageOrderValue'].toString());
    approvalPercentage = double.parse(json['ApprovalPercentage'].toString());
    abandonCartRatio = double.parse(json['AbandonCartRatio'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Label'] = label;
    data['ApprovedOrders'] = approvedOrders;
    data['AverageOrderValue'] = averageOrderValue;
    data['ApprovalPercentage'] = approvalPercentage;
    data['AbandonCartRatio'] = abandonCartRatio;
    return data;
  }
}
class DashBoardSecondData {
  DashBoardSecondData? result;

  DashBoardSecondData({this.result});

  DashBoardSecondData.fromJson(Map<String, dynamic> json) {
    result =
    json['Result'] != null ? DashBoardSecondData.fromJson(json['Result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['Result'] = result!.toJson();
    }
    return data;
  }
}

class DashBoardSecondDataResult {
  String? totalTransactions;
  String? refundTotal;
  String? chargebackTotal;

  DashBoardSecondDataResult({this.totalTransactions, this.refundTotal, this.chargebackTotal});

  DashBoardSecondDataResult.fromJson(Map<String, dynamic> json) {
    totalTransactions = '${json['TotalTransactions']}';
    refundTotal = "${json['RefundTotal']}";
    chargebackTotal = '${json['ChargebackTotal']}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalTransactions'] = totalTransactions;
    data['RefundTotal'] = refundTotal;
    data['ChargebackTotal'] = chargebackTotal;
    return data;
  }
}
class LifeTimeDataResponse {
  LifeTimeDataResult? result;
  String? currentTime;

  LifeTimeDataResponse({this.result, this.currentTime});

  LifeTimeDataResponse.fromJson(Map<String, dynamic> json) {
    result =
    json['Result'] != null ? LifeTimeDataResult.fromJson(json['Result']) : null;
    currentTime = json['CurrentTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['Result'] = result!.toJson();
    }
    data['CurrentTime'] = currentTime;
    return data;
  }
}

class LifeTimeDataResult {
  int? totalSubscriptions;
  int? cancelledSubscriptions;
  int? activeSubscriptions;
  int? subscriptionInSalvage;

  LifeTimeDataResult(
      {this.totalSubscriptions,
        this.cancelledSubscriptions,
        this.activeSubscriptions,
        this.subscriptionInSalvage});

  LifeTimeDataResult.fromJson(Map<String, dynamic> json) {
    totalSubscriptions = json['TotalSubscriptions'];
    cancelledSubscriptions = json['CancelledSubscriptions'];
    activeSubscriptions = json['ActiveSubscriptions'];
    subscriptionInSalvage = json['SubscriptionInSalvage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalSubscriptions'] = totalSubscriptions;
    data['CancelledSubscriptions'] = cancelledSubscriptions;
    data['ActiveSubscriptions'] = activeSubscriptions;
    data['SubscriptionInSalvage'] = subscriptionInSalvage;
    return data;
  }
}
